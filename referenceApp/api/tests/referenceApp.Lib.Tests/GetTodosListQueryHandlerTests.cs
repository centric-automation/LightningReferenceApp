using Xunit;
using Shouldly;
using referenceApp.Persistence;
using System.Threading.Tasks;
using System.Threading;
using referenceApp.Lib.Tests.Infrastructure;
using referenceApp.Lib.Todos.Queries;
using referenceApp.Lib.Todos.Models;

namespace referenceApp.Lib.Tests
{
	[Collection("QueryCollection")]
	public class GetTodosListQueryHandlerTests
	{
		private ReferenceDbContext _context;

		public GetTodosListQueryHandlerTests(QueryTestFixture fixture)
		{
			_context = fixture.Context;
		}

		[Fact]
		public async Task GetTodosListTest()
		{
			var handler = new GetTodosListQueryHandler(_context);
			var result = await handler.Handle(new GetTodosListQuery(), CancellationToken.None);

			result.ShouldBeOfType<TodoListModel>();
		}

		[Fact]
		public async Task ListShouldNotBeEmpty()
		{
			var handler = new GetTodosListQueryHandler(_context);
			var result = await handler.Handle(new GetTodosListQuery(), CancellationToken.None);

			result.Todos.Count.ShouldBe(3);
		}
	}
}
