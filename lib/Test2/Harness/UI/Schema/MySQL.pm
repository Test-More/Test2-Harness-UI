package Test2::Harness::UI::Schema::MySQL;
use utf8;
use strict;
use warnings;
use Carp();

our $VERSION = '0.000055';

# DO NOT MODIFY THIS FILE, GENERATED BY author_tools/regen_schema.pl

Carp::confess("Already loaded schema '$Test2::Harness::UI::Schema::LOADED'") if $Test2::Harness::UI::Schema::LOADED;

$Test2::Harness::UI::Schema::LOADED = "MySQL";

{
    package    #
        Test2::Harness::UI::Schema::Result::ApiKey;

    use base 'DBIx::Class::Core';
    __PACKAGE__->load_components(
        "InflateColumn::DateTime",
        "InflateColumn::Serializer",
        "InflateColumn::Serializer::JSON",
        "Tree::AdjacencyList",
        "UUIDColumns",
    );
    __PACKAGE__->table("api_keys");
    __PACKAGE__->add_columns(
        "api_key_id",
        {data_type => "char", is_nullable => 0, size => 36},
        "user_id",
        {data_type => "char", is_foreign_key => 1, is_nullable => 0, size => 36},
        "name",
        {data_type => "varchar", is_nullable => 0, size => 128},
        "value",
        {data_type => "varchar", is_nullable => 0, size => 36},
        "status",
        {
            data_type   => "enum",
            extra       => {list => ["active", "disabled", "revoked"]},
            is_nullable => 0,
        },
    );
    __PACKAGE__->set_primary_key("api_key_id");
    __PACKAGE__->add_unique_constraint("value", ["value"]);
    __PACKAGE__->belongs_to(
        "user",
        "Test2::Harness::UI::Schema::Result::User",
        {user_id       => "user_id"},
        {is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT"},
    );

}

{
    package    #
        Test2::Harness::UI::Schema::Result::Coverage;

    use base 'DBIx::Class::Core';
    __PACKAGE__->load_components(
        "InflateColumn::DateTime",
        "InflateColumn::Serializer",
        "InflateColumn::Serializer::JSON",
        "Tree::AdjacencyList",
        "UUIDColumns",
    );
    __PACKAGE__->table("coverage");
    __PACKAGE__->add_columns(
        "job_key",
        {data_type => "char", is_foreign_key => 1, is_nullable => 0, size => 36},
        "file",
        {data_type => "varchar", is_nullable => 0, size => 512},
    );
    __PACKAGE__->belongs_to(
        "job_key",
        "Test2::Harness::UI::Schema::Result::Job",
        {job_key       => "job_key"},
        {is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT"},
    );

}

{
    package    #
        Test2::Harness::UI::Schema::Result::Email;

    use base 'DBIx::Class::Core';
    __PACKAGE__->load_components(
        "InflateColumn::DateTime",
        "InflateColumn::Serializer",
        "InflateColumn::Serializer::JSON",
        "Tree::AdjacencyList",
        "UUIDColumns",
    );
    __PACKAGE__->table("email");
    __PACKAGE__->add_columns(
        "email_id",
        {data_type => "char", is_nullable => 0, size => 36},
        "user_id",
        {data_type => "char", is_foreign_key => 1, is_nullable => 0, size => 36},
        "local",
        {data_type => "varchar", is_nullable => 0, size => 128},
        "domain",
        {data_type => "varchar", is_nullable => 0, size => 128},
        "verified",
        {data_type => "tinyint", default_value => 0, is_nullable => 0},
    );
    __PACKAGE__->set_primary_key("email_id");
    __PACKAGE__->add_unique_constraint("local", ["local", "domain"]);
    __PACKAGE__->might_have(
        "email_verification_code",
        "Test2::Harness::UI::Schema::Result::EmailVerificationCode",
        {"foreign.email_id" => "self.email_id"},
        {cascade_copy       => 0, cascade_delete => 0},
    );
    __PACKAGE__->might_have(
        "primary_email",
        "Test2::Harness::UI::Schema::Result::PrimaryEmail",
        {"foreign.email_id" => "self.email_id"},
        {cascade_copy       => 0, cascade_delete => 0},
    );
    __PACKAGE__->belongs_to(
        "user",
        "Test2::Harness::UI::Schema::Result::User",
        {user_id       => "user_id"},
        {is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT"},
    );

}

{
    package    #
        Test2::Harness::UI::Schema::Result::EmailVerificationCode;

    use base 'DBIx::Class::Core';
    __PACKAGE__->load_components(
        "InflateColumn::DateTime",
        "InflateColumn::Serializer",
        "InflateColumn::Serializer::JSON",
        "Tree::AdjacencyList",
        "UUIDColumns",
    );
    __PACKAGE__->table("email_verification_codes");
    __PACKAGE__->add_columns(
        "evcode_id",
        {data_type => "char", is_nullable => 0, size => 36},
        "email_id",
        {data_type => "char", is_foreign_key => 1, is_nullable => 0, size => 36},
    );
    __PACKAGE__->set_primary_key("evcode_id");
    __PACKAGE__->add_unique_constraint("email_id", ["email_id"]);
    __PACKAGE__->belongs_to(
        "email",
        "Test2::Harness::UI::Schema::Result::Email",
        {email_id      => "email_id"},
        {is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT"},
    );

}

{
    package    #
        Test2::Harness::UI::Schema::Result::Event;

    use base 'DBIx::Class::Core';
    __PACKAGE__->load_components(
        "InflateColumn::DateTime",
        "InflateColumn::Serializer",
        "InflateColumn::Serializer::JSON",
        "Tree::AdjacencyList",
        "UUIDColumns",
    );
    __PACKAGE__->table("events");
    __PACKAGE__->add_columns(
        "event_id",
        {data_type => "char", is_nullable => 0, size => 36},
        "job_key",
        {data_type => "char", is_foreign_key => 1, is_nullable => 0, size => 36},
        "event_ord",
        {data_type => "bigint", is_nullable => 0},
        "insert_ord",
        {data_type => "bigint", is_auto_increment => 1, is_nullable => 0},
        "is_diag",
        {data_type => "tinyint", default_value => 0, is_nullable => 0},
        "is_harness",
        {data_type => "tinyint", default_value => 0, is_nullable => 0},
        "is_time",
        {data_type => "tinyint", default_value => 0, is_nullable => 0},
        "stamp",
        {
            data_type                 => "timestamp",
            datetime_undef_if_invalid => 1,
            is_nullable               => 1,
        },
        "parent_id",
        {data_type => "char", is_nullable => 1, size => 36},
        "trace_id",
        {data_type => "char", is_nullable => 1, size => 36},
        "nested",
        {data_type => "integer", default_value => 0, is_nullable => 1},
        "facets",
        {data_type => "json", is_nullable => 1},
        "facets_line",
        {data_type => "bigint", is_nullable => 1},
        "orphan",
        {data_type => "json", is_nullable => 1},
        "orphan_line",
        {data_type => "bigint", is_nullable => 1},
    );
    __PACKAGE__->set_primary_key("event_id");
    __PACKAGE__->add_unique_constraint("insert_ord", ["insert_ord"]);
    __PACKAGE__->belongs_to(
        "job_key",
        "Test2::Harness::UI::Schema::Result::Job",
        {job_key       => "job_key"},
        {is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT"},
    );

}

{
    package    #
        Test2::Harness::UI::Schema::Result::Job;

    use base 'DBIx::Class::Core';
    __PACKAGE__->load_components(
        "InflateColumn::DateTime",
        "InflateColumn::Serializer",
        "InflateColumn::Serializer::JSON",
        "Tree::AdjacencyList",
        "UUIDColumns",
    );
    __PACKAGE__->table("jobs");
    __PACKAGE__->add_columns(
        "job_key",
        {data_type => "char", is_nullable => 0, size => 36},
        "job_id",
        {data_type => "char", is_nullable => 0, size => 36},
        "job_try",
        {data_type => "integer", default_value => 0, is_nullable => 0},
        "job_ord",
        {data_type => "bigint", is_nullable => 0},
        "run_id",
        {data_type => "char", is_foreign_key => 1, is_nullable => 0, size => 36},
        "is_harness_out",
        {data_type => "tinyint", default_value => 0, is_nullable => 0},
        "status",
        {
            data_type => "enum",
            extra     => {
                list => ["pending", "running", "complete", "broken", "canceled"],
            },
            is_nullable => 0,
        },
        "parameters",
        {data_type => "json", is_nullable => 1},
        "fields",
        {data_type => "json", is_nullable => 1},
        "name",
        {data_type => "text", is_nullable => 1},
        "file",
        {data_type => "varchar", is_nullable => 1, size => 512},
        "fail",
        {data_type => "tinyint", is_nullable => 1},
        "retry",
        {data_type => "tinyint", is_nullable => 1},
        "exit_code",
        {data_type => "integer", is_nullable => 1},
        "launch",
        {
            data_type                 => "timestamp",
            datetime_undef_if_invalid => 1,
            is_nullable               => 1,
        },
        "start",
        {
            data_type                 => "timestamp",
            datetime_undef_if_invalid => 1,
            is_nullable               => 1,
        },
        "ended",
        {
            data_type                 => "timestamp",
            datetime_undef_if_invalid => 1,
            is_nullable               => 1,
        },
        "duration",
        {data_type => "double precision", is_nullable => 1},
        "pass_count",
        {data_type => "bigint", is_nullable => 1},
        "fail_count",
        {data_type => "bigint", is_nullable => 1},
        "stdout",
        {data_type => "longtext", is_nullable => 1},
        "stderr",
        {data_type => "longtext", is_nullable => 1},
    );
    __PACKAGE__->set_primary_key("job_key");
    __PACKAGE__->add_unique_constraint("job_id", ["job_id", "job_try"]);
    __PACKAGE__->has_many(
        "coverages",
        "Test2::Harness::UI::Schema::Result::Coverage",
        {"foreign.job_key" => "self.job_key"},
        {cascade_copy      => 0, cascade_delete => 0},
    );
    __PACKAGE__->has_many(
        "events",
        "Test2::Harness::UI::Schema::Result::Event",
        {"foreign.job_key" => "self.job_key"},
        {cascade_copy      => 0, cascade_delete => 0},
    );
    __PACKAGE__->belongs_to(
        "run",
        "Test2::Harness::UI::Schema::Result::Run",
        {run_id        => "run_id"},
        {is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT"},
    );

}

{
    package    #
        Test2::Harness::UI::Schema::Result::LogFile;

    use base 'DBIx::Class::Core';
    __PACKAGE__->load_components(
        "InflateColumn::DateTime",
        "InflateColumn::Serializer",
        "InflateColumn::Serializer::JSON",
        "Tree::AdjacencyList",
        "UUIDColumns",
    );
    __PACKAGE__->table("log_files");
    __PACKAGE__->add_columns(
        "log_file_id",
        {data_type => "char", is_nullable => 0, size => 36},
        "name",
        {data_type => "text", is_nullable => 0},
        "local_file",
        {data_type => "text", is_nullable => 1},
        "data",
        {data_type => "longblob", is_nullable => 1},
    );
    __PACKAGE__->set_primary_key("log_file_id");
    __PACKAGE__->has_many(
        "runs",
        "Test2::Harness::UI::Schema::Result::Run",
        {"foreign.log_file_id" => "self.log_file_id"},
        {cascade_copy          => 0, cascade_delete => 0},
    );

}

{
    package    #
        Test2::Harness::UI::Schema::Result::Permission;

    use base 'DBIx::Class::Core';
    __PACKAGE__->load_components(
        "InflateColumn::DateTime",
        "InflateColumn::Serializer",
        "InflateColumn::Serializer::JSON",
        "Tree::AdjacencyList",
        "UUIDColumns",
    );
    __PACKAGE__->table("permissions");
    __PACKAGE__->add_columns(
        "permission_id",
        {data_type => "char", is_nullable => 0, size => 36},
        "project_id",
        {data_type => "char", is_foreign_key => 1, is_nullable => 0, size => 36},
        "user_id",
        {data_type => "char", is_foreign_key => 1, is_nullable => 0, size => 36},
        "updated",
        {
            data_type                 => "timestamp",
            datetime_undef_if_invalid => 1,
            default_value             => \"current_timestamp",
            is_nullable               => 0,
        },
        "cpan_batch",
        {data_type => "bigint", is_nullable => 1},
    );
    __PACKAGE__->set_primary_key("permission_id");
    __PACKAGE__->add_unique_constraint("project_id", ["project_id", "user_id"]);
    __PACKAGE__->belongs_to(
        "project",
        "Test2::Harness::UI::Schema::Result::Project",
        {project_id    => "project_id"},
        {is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT"},
    );
    __PACKAGE__->belongs_to(
        "user",
        "Test2::Harness::UI::Schema::Result::User",
        {user_id       => "user_id"},
        {is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT"},
    );

}

{
    package    #
        Test2::Harness::UI::Schema::Result::PrimaryEmail;

    use base 'DBIx::Class::Core';
    __PACKAGE__->load_components(
        "InflateColumn::DateTime",
        "InflateColumn::Serializer",
        "InflateColumn::Serializer::JSON",
        "Tree::AdjacencyList",
        "UUIDColumns",
    );
    __PACKAGE__->table("primary_email");
    __PACKAGE__->add_columns(
        "user_id",
        {data_type => "char", is_foreign_key => 1, is_nullable => 0, size => 36},
        "email_id",
        {data_type => "char", is_foreign_key => 1, is_nullable => 0, size => 36},
    );
    __PACKAGE__->set_primary_key("user_id");
    __PACKAGE__->add_unique_constraint("email_id", ["email_id"]);
    __PACKAGE__->belongs_to(
        "email",
        "Test2::Harness::UI::Schema::Result::Email",
        {email_id      => "email_id"},
        {is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT"},
    );
    __PACKAGE__->belongs_to(
        "user",
        "Test2::Harness::UI::Schema::Result::User",
        {user_id       => "user_id"},
        {is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT"},
    );

}

{
    package    #
        Test2::Harness::UI::Schema::Result::Project;

    use base 'DBIx::Class::Core';
    __PACKAGE__->load_components(
        "InflateColumn::DateTime",
        "InflateColumn::Serializer",
        "InflateColumn::Serializer::JSON",
        "Tree::AdjacencyList",
        "UUIDColumns",
    );
    __PACKAGE__->table("projects");
    __PACKAGE__->add_columns(
        "project_id",
        {data_type => "char", is_nullable => 0, size => 36},
        "name",
        {data_type => "varchar", is_nullable => 0, size => 128},
    );
    __PACKAGE__->set_primary_key("project_id");
    __PACKAGE__->add_unique_constraint("name", ["name"]);
    __PACKAGE__->has_many(
        "permissions",
        "Test2::Harness::UI::Schema::Result::Permission",
        {"foreign.project_id" => "self.project_id"},
        {cascade_copy         => 0, cascade_delete => 0},
    );
    __PACKAGE__->has_many(
        "runs",
        "Test2::Harness::UI::Schema::Result::Run",
        {"foreign.project_id" => "self.project_id"},
        {cascade_copy         => 0, cascade_delete => 0},
    );

}

{
    package    #
        Test2::Harness::UI::Schema::Result::Run;

    use base 'DBIx::Class::Core';
    __PACKAGE__->load_components(
        "InflateColumn::DateTime",
        "InflateColumn::Serializer",
        "InflateColumn::Serializer::JSON",
        "Tree::AdjacencyList",
        "UUIDColumns",
    );
    __PACKAGE__->table("runs");
    __PACKAGE__->add_columns(
        "run_id",
        {data_type => "char", is_nullable => 0, size => 36},
        "user_id",
        {data_type => "char", is_foreign_key => 1, is_nullable => 0, size => 36},
        "run_ord",
        {data_type => "bigint", is_auto_increment => 1, is_nullable => 0},
        "status",
        {
            data_type => "enum",
            extra     => {
                list => ["pending", "running", "complete", "broken", "canceled"],
            },
            is_nullable => 0,
        },
        "worker_id",
        {data_type => "text", is_nullable => 1},
        "error",
        {data_type => "text", is_nullable => 1},
        "project_id",
        {data_type => "char", is_foreign_key => 1, is_nullable => 0, size => 36},
        "pinned",
        {data_type => "tinyint", default_value => 0, is_nullable => 0},
        "added",
        {
            data_type                 => "timestamp",
            datetime_undef_if_invalid => 1,
            default_value             => \"current_timestamp",
            is_nullable               => 0,
        },
        "duration",
        {data_type => "text", is_nullable => 1},
        "log_file_id",
        {data_type => "char", is_foreign_key => 1, is_nullable => 1, size => 36},
        "mode",
        {
            data_type   => "enum",
            extra       => {list => ["qvfd", "qvf", "summary", "complete"]},
            is_nullable => 0,
        },
        "buffer",
        {
            data_type     => "enum",
            default_value => "job",
            extra         => {list => ["none", "diag", "job", "run"]},
            is_nullable   => 0,
        },
        "passed",
        {data_type => "integer", is_nullable => 1},
        "failed",
        {data_type => "integer", is_nullable => 1},
        "retried",
        {data_type => "integer", is_nullable => 1},
        "concurrency",
        {data_type => "integer", is_nullable => 1},
        "fields",
        {data_type => "json", is_nullable => 1},
        "parameters",
        {data_type => "json", is_nullable => 1},
    );
    __PACKAGE__->set_primary_key("run_id");
    __PACKAGE__->add_unique_constraint("run_ord", ["run_ord"]);
    __PACKAGE__->has_many(
        "jobs",
        "Test2::Harness::UI::Schema::Result::Job",
        {"foreign.run_id" => "self.run_id"},
        {cascade_copy     => 0, cascade_delete => 0},
    );
    __PACKAGE__->belongs_to(
        "log_file",
        "Test2::Harness::UI::Schema::Result::LogFile",
        {log_file_id => "log_file_id"},
        {
            is_deferrable => 1,
            join_type     => "LEFT",
            on_delete     => "RESTRICT",
            on_update     => "RESTRICT",
        },
    );
    __PACKAGE__->belongs_to(
        "project",
        "Test2::Harness::UI::Schema::Result::Project",
        {project_id    => "project_id"},
        {is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT"},
    );
    __PACKAGE__->belongs_to(
        "user",
        "Test2::Harness::UI::Schema::Result::User",
        {user_id       => "user_id"},
        {is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT"},
    );

}

{
    package    #
        Test2::Harness::UI::Schema::Result::Session;

    use base 'DBIx::Class::Core';
    __PACKAGE__->load_components(
        "InflateColumn::DateTime",
        "InflateColumn::Serializer",
        "InflateColumn::Serializer::JSON",
        "Tree::AdjacencyList",
        "UUIDColumns",
    );
    __PACKAGE__->table("sessions");
    __PACKAGE__->add_columns(
        "session_id",
        {data_type => "char", is_nullable => 0, size => 36},
        "active",
        {data_type => "tinyint", default_value => 1, is_nullable => 1},
    );
    __PACKAGE__->set_primary_key("session_id");
    __PACKAGE__->has_many(
        "session_hosts",
        "Test2::Harness::UI::Schema::Result::SessionHost",
        {"foreign.session_id" => "self.session_id"},
        {cascade_copy         => 0, cascade_delete => 0},
    );

}

{
    package    #
        Test2::Harness::UI::Schema::Result::SessionHost;

    use base 'DBIx::Class::Core';
    __PACKAGE__->load_components(
        "InflateColumn::DateTime",
        "InflateColumn::Serializer",
        "InflateColumn::Serializer::JSON",
        "Tree::AdjacencyList",
        "UUIDColumns",
    );
    __PACKAGE__->table("session_hosts");
    __PACKAGE__->add_columns(
        "session_host_id",
        {data_type => "char", is_nullable => 0, size => 36},
        "session_id",
        {data_type => "char", is_foreign_key => 1, is_nullable => 0, size => 36},
        "user_id",
        {data_type => "char", is_foreign_key => 1, is_nullable => 1, size => 36},
        "created",
        {
            data_type                 => "timestamp",
            datetime_undef_if_invalid => 1,
            default_value             => \"current_timestamp",
            is_nullable               => 0,
        },
        "accessed",
        {
            data_type                 => "timestamp",
            datetime_undef_if_invalid => 1,
            default_value             => \"current_timestamp",
            is_nullable               => 0,
        },
        "address",
        {data_type => "varchar", is_nullable => 0, size => 128},
        "agent",
        {data_type => "varchar", is_nullable => 0, size => 128},
    );
    __PACKAGE__->set_primary_key("session_host_id");
    __PACKAGE__->add_unique_constraint("session_id", ["session_id", "address", "agent"]);
    __PACKAGE__->belongs_to(
        "session",
        "Test2::Harness::UI::Schema::Result::Session",
        {session_id    => "session_id"},
        {is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT"},
    );
    __PACKAGE__->belongs_to(
        "user",
        "Test2::Harness::UI::Schema::Result::User",
        {user_id => "user_id"},
        {
            is_deferrable => 1,
            join_type     => "LEFT",
            on_delete     => "RESTRICT",
            on_update     => "RESTRICT",
        },
    );

}

{
    package    #
        Test2::Harness::UI::Schema::Result::User;

    use base 'DBIx::Class::Core';
    __PACKAGE__->load_components(
        "InflateColumn::DateTime",
        "InflateColumn::Serializer",
        "InflateColumn::Serializer::JSON",
        "Tree::AdjacencyList",
        "UUIDColumns",
    );
    __PACKAGE__->table("users");
    __PACKAGE__->add_columns(
        "user_id",
        {data_type => "char", is_nullable => 0, size => 36},
        "username",
        {data_type => "varchar", is_nullable => 0, size => 64},
        "pw_hash",
        {data_type => "varchar", is_nullable => 1, size => 31},
        "pw_salt",
        {data_type => "varchar", is_nullable => 1, size => 22},
        "realname",
        {data_type => "varchar", is_nullable => 1, size => 64},
        "role",
        {
            data_type   => "enum",
            extra       => {list => ["admin", "user"]},
            is_nullable => 0,
        },
    );
    __PACKAGE__->set_primary_key("user_id");
    __PACKAGE__->add_unique_constraint("username", ["username"]);
    __PACKAGE__->has_many(
        "api_keys",
        "Test2::Harness::UI::Schema::Result::ApiKey",
        {"foreign.user_id" => "self.user_id"},
        {cascade_copy      => 0, cascade_delete => 0},
    );
    __PACKAGE__->has_many(
        "emails",
        "Test2::Harness::UI::Schema::Result::Email",
        {"foreign.user_id" => "self.user_id"},
        {cascade_copy      => 0, cascade_delete => 0},
    );
    __PACKAGE__->has_many(
        "permissions",
        "Test2::Harness::UI::Schema::Result::Permission",
        {"foreign.user_id" => "self.user_id"},
        {cascade_copy      => 0, cascade_delete => 0},
    );
    __PACKAGE__->might_have(
        "primary_email",
        "Test2::Harness::UI::Schema::Result::PrimaryEmail",
        {"foreign.user_id" => "self.user_id"},
        {cascade_copy      => 0, cascade_delete => 0},
    );
    __PACKAGE__->has_many(
        "runs",
        "Test2::Harness::UI::Schema::Result::Run",
        {"foreign.user_id" => "self.user_id"},
        {cascade_copy      => 0, cascade_delete => 0},
    );
    __PACKAGE__->has_many(
        "session_hosts",
        "Test2::Harness::UI::Schema::Result::SessionHost",
        {"foreign.user_id" => "self.user_id"},
        {cascade_copy      => 0, cascade_delete => 0},
    );

}

1;
