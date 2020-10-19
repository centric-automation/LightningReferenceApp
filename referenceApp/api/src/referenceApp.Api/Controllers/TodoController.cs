using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using referenceApp.Lib.Todos.Models;
using referenceApp.Lib.Todos.Queries;

namespace referenceApp.Api.Controllers
{
	public class TodoController : ApiControllerBase
	{
		[HttpGet]
		[Produces("application/json")]
		[ProducesResponseType(StatusCodes.Status200OK)]
		public async Task<TodoListModel> List()
		{
			return await Mediator.Send(new GetTodosListQuery());
		}
	}
}
