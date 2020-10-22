using MediatR;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.DependencyInjection;

namespace referenceApp.Api.Controllers
{
	[ApiController]
	[Route("api/[controller]")]
	public abstract class ApiControllerBase : ControllerBase
	{
		private IMediator _mediator;

		protected IMediator Mediator => _mediator ?? (_mediator = ControllerContext.HttpContext.RequestServices.GetService<IMediator>());
	}
}
