using System;
using referenceApp.Persistence;
using Microsoft.EntityFrameworkCore;

namespace referenceApp.Lib.Tests.Infrastructure
{
	public class ReferenceDbContextFactory
	{
		public static ReferenceDbContext Create()
		{
			var options = new DbContextOptionsBuilder<ReferenceDbContext>()
					.UseInMemoryDatabase(Guid.NewGuid().ToString())
					.Options;

			var context = new ReferenceDbContext(options);

			context.Database.EnsureCreated();

			return context;
		}

		public static void Destroy(ReferenceDbContext context)
		{
			if (!context.Database.IsInMemory()) return;
			
			context.Database.EnsureDeleted();

			context.Dispose();
		}
	}
}
