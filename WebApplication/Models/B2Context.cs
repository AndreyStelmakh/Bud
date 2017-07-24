using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;

namespace WebApplication.Models
{
    public partial class B2Context : IdentityDbContext<ApplicationUser>
    {
        public virtual DbSet<Budget> Budget { get; set; }
        public virtual DbSet<Distributions> Distributions { get; set; }
        public virtual DbSet<DistributionsDetails> DistributionsDetails { get; set; }
        public virtual DbSet<Earnings> Earnings { get; set; }
        public virtual DbSet<Expenditure> Expenditure { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            #warning To protect potentially sensitive information in your connection string, you should move it out of source code. See http://go.microsoft.com/fwlink/?LinkId=723263 for guidance on storing connection strings.
            optionsBuilder.UseSqlServer(@"Data Source=(localdb)\ProjectsV13;Initial Catalog=B2;Integrated Security=True;Connect Timeout=30;Encrypt=False;TrustServerCertificate=True;ApplicationIntent=ReadWrite;MultiSubnetFailover=False");
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Budget>(entity =>
            {
                entity.HasKey(e => new { e.IncomeId, e.ExpenditureId })
                    .HasName("PK__Budget__A51FBAE6EAFF8FB7");

                entity.ToTable("Budget", "budget");

                entity.Property(e => e.Value).HasColumnType("decimal");

                entity.HasOne(d => d.Expenditure)
                    .WithMany(p => p.Budget)
                    .HasForeignKey(d => d.ExpenditureId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Budget_to_Expenditure");

                entity.HasOne(d => d.Income)
                    .WithMany(p => p.Budget)
                    .HasForeignKey(d => d.IncomeId)
                    .HasConstraintName("FK_Budget_to_Earnings");
            });

            modelBuilder.Entity<Distributions>(entity =>
            {
                entity.ToTable("Distributions", "budget");

                entity.Property(e => e.Id).HasDefaultValueSql("newid()");

                entity.Property(e => e.Title)
                    .IsRequired()
                    .HasMaxLength(24);
            });

            modelBuilder.Entity<DistributionsDetails>(entity =>
            {
                entity.HasKey(e => new { e.DistributionId, e.ExpenditureId })
                    .HasName("PK_DistributionsDetails");

                entity.ToTable("DistributionsDetails", "budget");

                entity.Property(e => e.Percentage).HasColumnType("numeric");

                entity.HasOne(d => d.Distribution)
                    .WithMany(p => p.DistributionsDetails)
                    .HasForeignKey(d => d.DistributionId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_DistributionsDetails_to_Distributions");

                entity.HasOne(d => d.Expenditure)
                    .WithMany(p => p.DistributionsDetails)
                    .HasForeignKey(d => d.ExpenditureId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_DistributionsDetails_to_Expenditure");
            });

            modelBuilder.Entity<Earnings>(entity =>
            {
                entity.ToTable("Earnings", "budget");

                entity.Property(e => e.Id).HasDefaultValueSql("newid()");

                entity.Property(e => e.Properties).HasColumnType("xml");

                entity.Property(e => e.RegisteredAt).HasColumnType("datetime2(2)");

                entity.Property(e => e.Tool)
                    .IsRequired()
                    .HasColumnType("nchar(6)");
            });

            modelBuilder.Entity<Expenditure>(entity =>
            {
                entity.ToTable("Expenditure", "budget");

                entity.Property(e => e.Id).HasDefaultValueSql("newid()");

                entity.Property(e => e.Properties).HasColumnType("xml");

                entity.Property(e => e.Title)
                    .IsRequired()
                    .HasMaxLength(100);
            });
        }
    }
}