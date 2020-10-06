using System;

namespace referenceApp.Persistence.Models
{
	public class Todo
	{
		public Guid Id { get; set; }
		public string Title { get; set; }
		public DateTime? DueDate { get; set; }
		public DateTime WhenCreated { get; set; }
	}
}
