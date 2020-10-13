using System;
using referenceApp.Persistence;
using Microsoft.EntityFrameworkCore;

namespace referenceApp.Lib.Tests
{
	public abstract class DbTestBase
	{
		public ReferenceDbContext GetDbContext(bool useSqlLite = false)
		{
			var builder = new DbContextOptionsBuilder<ReferenceDbContext>();

			if (useSqlLite) { builder.UseSqlite("DataSource=:memory:", x => { }); }
			else { builder.UseInMemoryDatabase(Guid.NewGuid().ToString()); }

			var dbContext = new ReferenceDbContext(builder.Options);
			if (useSqlLite) { dbContext.Database.OpenConnection(); }

			dbContext.Database.EnsureCreated();

			return dbContext;
		}
	}
}
