using System;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;
using System.Threading;
using referenceApp.Persistence.Models;
using referenceApp.Persistence;

namespace referenceApp.Lib.Todos.CreateNewTodo
{
	public class CreateNewTodoCommandHandler : IRequestHandler<CreateNewTodoCommand, Unit>
	{
		private readonly ReferenceDbContext _context;

		public CreateNewTodoCommandHandler(ReferenceDbContext context) {
			_context = context;
		}

		public async Task<Unit> Handle(CreateNewTodoCommand request, CancellationToken cancellationToken)
		{
			var newTodo = new Todo();

			newTodo.Id = request.Id;
			newTodo.Title = request.Title;
			newTodo.DueDate = request.DueDate;
			newTodo.WhenCreated = request.WhenCreated;

			await _context.Todos.AddAsync(newTodo, cancellationToken);

			await _context.SaveChangesAsync(cancellationToken);

			return Unit.Value;
		}	
	}
}