using System;

namespace referenceApp.Lib.Todos.Models
{
	public class TodoModel
	{
		public Guid Id { get; set; }
		public string Title { get; set; }
		public DateTime? DueDate { get; set; }
		public DateTime WhenCreated { get; set; }
	}
}