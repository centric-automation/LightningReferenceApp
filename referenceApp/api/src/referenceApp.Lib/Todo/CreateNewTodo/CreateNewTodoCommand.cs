using System;
using MediatR;

namespace referenceApp.Lib.Todos.CreateNewTodo
{
	public class CreateNewTodoCommand : IRequest
	{
		public Guid Id { get; set; }
		public string Title { get; set; }
		public DateTime WhenCreated { get; set; } = DateTime.UtcNow;
		public DateTime? DueDate { get; set; }
	}
}