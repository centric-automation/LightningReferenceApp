using Xunit;
using Shouldly;
using referenceApp.Persistence;
using referenceApp.Lib.Todos.CreateNewTodo;
using System;
using System.Threading.Tasks;
using referenceApp.Persistence.Models;
using System.Threading;

namespace referenceApp.Lib.Tests
{
	public class UnitTest1
	{
		[Fact]
		public void Test1()
		{
			true.ShouldBeTrue();
		}
	}

	public class CreateNewTodoCommandHandlerTests : DbTestBase
	{
		private ReferenceDbContext _context;
		private CreateNewTodoCommandHandler _commandHandler;
		private CreateNewTodoCommand _command;

		public CreateNewTodoCommandHandlerTests()
		{
			_context = GetDbContext(false);
			_commandHandler = new CreateNewTodoCommandHandler(_context);
			_command = new CreateNewTodoCommand()
			{
				Id = Guid.NewGuid(),
				Title = "Test One",
			};
		}

		[Fact]
		public async Task ShouldCreate()
		{
				var entity = await ExecuteCommand();
				entity.ShouldNotBeNull();
		}

		[Fact]
		public async Task ShouldHavePropertiesSet()
		{
			var entity = await ExecuteCommand();
			entity.Id.ShouldBe(_command.Id);
			entity.Title.ShouldBe(_command.Title);
			entity.DueDate.ShouldBe(_command.DueDate);
			entity.WhenCreated.ShouldBe(_command.WhenCreated);
		}

		private async Task<Todo> ExecuteCommand()
		{
			await _commandHandler.Handle(_command, CancellationToken.None);

			return await _context.Todos.FindAsync(_command.Id);
		}
	}
}
