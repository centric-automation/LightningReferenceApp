using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using MediatR;
using MediatR.Pipeline;
using referenceApp.Lib.Infrastructure;
using referenceApp.Lib.Todos.Queries;
using System.Reflection;
using referenceApp.Persistence;
using Microsoft.EntityFrameworkCore;

namespace referenceApp.Api
{
	public class Startup
	{
		public Startup(IConfiguration configuration)
		{
			Configuration = configuration;
		}

		public IConfiguration Configuration { get; }

		// This method gets called by the runtime. Use this method to add services to the container.
		public virtual void ConfigureServices(IServiceCollection services)
		{
			services.AddControllers();

			// Add MediatR and load handlers from Lib project
			services.AddTransient(typeof(IPipelineBehavior<,>), typeof(RequestPreProcessorBehavior<,>));
			services.AddTransient(typeof(IPipelineBehavior<,>), typeof(RequestPerformanceBehavior<,>));
			services.AddTransient(typeof(IPipelineBehavior<,>), typeof(RequestValidationBehavior<,>));
			services.AddMediatR(typeof(GetTodosListQueryHandler).GetTypeInfo().Assembly);

			services.AddSwaggerDocument(document =>
			{
				document.DocumentName = "latest";
				document.Title = "ReferenceApp API";
				document.Description = "API routes for interacting with ReferenceApp services.";
			});

			// FOR DEMONSTRATION PURPOSES
			//services.AddDbContext<ReferenceDbContext> (options => options.UseSqlite("Data Source=todo.db"));
			services.AddDbContext<ReferenceDbContext> (
				options => options.UseSqlServer(
					Configuration.GetConnectionString("ReferenceAppConnectionString"),
					optionsBiuilder => optionsBiuilder.MigrationsAssembly("referenceApp.Api"))
			);
			// services.AddDbContext<ReferenceDbContext>(options => options.UseInMemoryDatabase(Guid.NewGuid().ToString()));
		}

		// This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
		public virtual void Configure(IApplicationBuilder app, IWebHostEnvironment env)
		{

			if (env.IsDevelopment())
			{
				app.UseDeveloperExceptionPage();
			}

			app.UseHttpsRedirection();

			app.UseRouting();

			app.UseAuthorization();

			app.UseEndpoints(endpoints =>
			{
				endpoints.MapControllers();
			});

			app.UseOpenApi();
			app.UseSwaggerUi3();
		}
	}
}
