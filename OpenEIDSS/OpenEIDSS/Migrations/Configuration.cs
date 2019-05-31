namespace OpenEIDSS.Migrations
{
    using Microsoft.AspNet.Identity.EntityFramework;
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Migrations;
    using System.Linq;

    internal sealed class Configuration : DbMigrationsConfiguration<OpenEIDSS.Models.ApplicationDbContext>
    {
        public Configuration()
        {
            AutomaticMigrationsEnabled = true;
        }

        protected override void Seed(OpenEIDSS.Models.ApplicationDbContext context)
        {
           //  You can use the DbSet<T>.AddOrUpdate() helper extension method 
           //  to avoid creating duplicate seed data.

        }

    }
}
