package Test2::Harness::UI::Schema::PostgreSQL;
use utf8;
use strict;
use warnings;
use Carp();

our $VERSION = '0.000081';

# DO NOT MODIFY THIS FILE, GENERATED BY author_tools/regen_schema.pl

Carp::confess("Already loaded schema '$Test2::Harness::UI::Schema::LOADED'") if $Test2::Harness::UI::Schema::LOADED;

$Test2::Harness::UI::Schema::LOADED = "PostgreSQL";

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
        {
            data_type     => "uuid",
            default_value => \"uuid_generate_v4()",
            is_nullable   => 0,
            size          => 16,
        },
        "user_id",
        {data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16},
        "name",
        {data_type => "varchar", is_nullable => 0, size => 128},
        "value",
        {data_type => "varchar", is_nullable => 0, size => 36},
        "status",
        {
            data_type     => "enum",
            default_value => "active",
            extra         => {
                custom_type_name => "api_key_status",
                list             => ["active", "disabled", "revoked"],
            },
            is_nullable => 0,
        },
    );
    __PACKAGE__->set_primary_key("api_key_id");
    __PACKAGE__->add_unique_constraint("api_keys_value_key", ["value"]);
    __PACKAGE__->belongs_to(
        "user",
        "Test2::Harness::UI::Schema::Result::User",
        {user_id       => "user_id"},
        {is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION"},
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
        {
            data_type     => "uuid",
            default_value => \"uuid_generate_v4()",
            is_nullable   => 0,
            size          => 16,
        },
        "user_id",
        {data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16},
        "local",
        {data_type => "citext", is_nullable => 0},
        "domain",
        {data_type => "citext", is_nullable => 0},
        "verified",
        {data_type => "boolean", default_value => \"false", is_nullable => 0},
    );
    __PACKAGE__->set_primary_key("email_id");
    __PACKAGE__->add_unique_constraint("email_local_domain_key", ["local", "domain"]);
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
        {is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION"},
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
        {
            data_type     => "uuid",
            default_value => \"uuid_generate_v4()",
            is_nullable   => 0,
            size          => 16,
        },
        "email_id",
        {data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16},
    );
    __PACKAGE__->set_primary_key("evcode_id");
    __PACKAGE__->add_unique_constraint("email_verification_codes_email_id_key", ["email_id"]);
    __PACKAGE__->belongs_to(
        "email",
        "Test2::Harness::UI::Schema::Result::Email",
        {email_id      => "email_id"},
        {is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION"},
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
        {data_type => "uuid", is_nullable => 0, size => 16},
        "job_key",
        {data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16},
        "event_ord",
        {data_type => "bigint", is_nullable => 0},
        "insert_ord",
        {
            data_type         => "bigint",
            is_auto_increment => 1,
            is_nullable       => 0,
            sequence          => "events_insert_ord_seq",
        },
        "is_subtest",
        {data_type => "boolean", default_value => \"false", is_nullable => 0},
        "is_diag",
        {data_type => "boolean", default_value => \"false", is_nullable => 0},
        "is_harness",
        {data_type => "boolean", default_value => \"false", is_nullable => 0},
        "is_time",
        {data_type => "boolean", default_value => \"false", is_nullable => 0},
        "stamp",
        {data_type => "timestamp", is_nullable => 1},
        "parent_id",
        {data_type => "uuid", is_nullable => 1, size => 16},
        "trace_id",
        {data_type => "uuid", is_nullable => 1, size => 16},
        "nested",
        {data_type => "integer", default_value => 0, is_nullable => 1},
        "facets",
        {data_type => "jsonb", is_nullable => 1},
        "facets_line",
        {data_type => "bigint", is_nullable => 1},
        "orphan",
        {data_type => "jsonb", is_nullable => 1},
        "orphan_line",
        {data_type => "bigint", is_nullable => 1},
    );
    __PACKAGE__->set_primary_key("event_id");
    __PACKAGE__->belongs_to(
        "job_key",
        "Test2::Harness::UI::Schema::Result::Job",
        {job_key       => "job_key"},
        {is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION"},
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
        {data_type => "uuid", is_nullable => 0, size => 16},
        "job_id",
        {data_type => "uuid", is_nullable => 0, size => 16},
        "job_try",
        {data_type => "integer", default_value => 0, is_nullable => 0},
        "job_ord",
        {data_type => "bigint", is_nullable => 0},
        "run_id",
        {data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16},
        "is_harness_out",
        {data_type => "boolean", default_value => \"false", is_nullable => 0},
        "status",
        {
            data_type     => "enum",
            default_value => "pending",
            extra         => {
                custom_type_name => "queue_status",
                list             => ["pending", "running", "complete", "broken", "canceled"],
            },
            is_nullable => 0,
        },
        "parameters",
        {data_type => "jsonb", is_nullable => 1},
        "name",
        {data_type => "text", is_nullable => 1},
        "file",
        {data_type => "text", is_nullable => 1},
        "fail",
        {data_type => "boolean", is_nullable => 1},
        "retry",
        {data_type => "boolean", is_nullable => 1},
        "exit_code",
        {data_type => "integer", is_nullable => 1},
        "launch",
        {data_type => "timestamp", is_nullable => 1},
        "start",
        {data_type => "timestamp", is_nullable => 1},
        "ended",
        {data_type => "timestamp", is_nullable => 1},
        "duration",
        {data_type => "double precision", is_nullable => 1},
        "pass_count",
        {data_type => "bigint", is_nullable => 1},
        "fail_count",
        {data_type => "bigint", is_nullable => 1},
        "stdout",
        {data_type => "text", is_nullable => 1},
        "stderr",
        {data_type => "text", is_nullable => 1},
    );
    __PACKAGE__->set_primary_key("job_key");
    __PACKAGE__->add_unique_constraint("jobs_job_id_job_try_key", ["job_id", "job_try"]);
    __PACKAGE__->has_many(
        "events",
        "Test2::Harness::UI::Schema::Result::Event",
        {"foreign.job_key" => "self.job_key"},
        {cascade_copy      => 0, cascade_delete => 0},
    );
    __PACKAGE__->has_many(
        "job_fields",
        "Test2::Harness::UI::Schema::Result::JobField",
        {"foreign.job_key" => "self.job_key"},
        {cascade_copy      => 0, cascade_delete => 0},
    );
    __PACKAGE__->belongs_to(
        "run",
        "Test2::Harness::UI::Schema::Result::Run",
        {run_id        => "run_id"},
        {is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION"},
    );

}

{
    package    #
        Test2::Harness::UI::Schema::Result::JobField;

    use base 'DBIx::Class::Core';
    __PACKAGE__->load_components(
        "InflateColumn::DateTime",
        "InflateColumn::Serializer",
        "InflateColumn::Serializer::JSON",
        "Tree::AdjacencyList",
        "UUIDColumns",
    );
    __PACKAGE__->table("job_fields");
    __PACKAGE__->add_columns(
        "job_field_id",
        {data_type => "uuid", is_nullable => 0, size => 16},
        "job_key",
        {data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16},
        "name",
        {data_type => "varchar", is_nullable => 0, size => 255},
        "data",
        {data_type => "jsonb", is_nullable => 1},
        "details",
        {data_type => "text", is_nullable => 1},
        "raw",
        {data_type => "text", is_nullable => 1},
        "link",
        {data_type => "text", is_nullable => 1},
    );
    __PACKAGE__->set_primary_key("job_field_id");
    __PACKAGE__->add_unique_constraint("job_fields_job_key_name_key", ["job_key", "name"]);
    __PACKAGE__->belongs_to(
        "job_key",
        "Test2::Harness::UI::Schema::Result::Job",
        {job_key       => "job_key"},
        {is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION"},
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
        {
            data_type     => "uuid",
            default_value => \"uuid_generate_v4()",
            is_nullable   => 0,
            size          => 16,
        },
        "name",
        {data_type => "text", is_nullable => 0},
        "local_file",
        {data_type => "text", is_nullable => 1},
        "data",
        {data_type => "bytea", is_nullable => 1},
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
        {
            data_type     => "uuid",
            default_value => \"uuid_generate_v4()",
            is_nullable   => 0,
            size          => 16,
        },
        "project_id",
        {data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16},
        "user_id",
        {data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16},
        "updated",
        {
            data_type     => "timestamp",
            default_value => \"current_timestamp",
            is_nullable   => 0,
            original      => {default_value => \"now()"},
        },
        "cpan_batch",
        {data_type => "bigint", is_nullable => 1},
    );
    __PACKAGE__->set_primary_key("permission_id");
    __PACKAGE__->add_unique_constraint(
        "permissions_project_id_user_id_key",
        ["project_id", "user_id"],
    );
    __PACKAGE__->belongs_to(
        "project",
        "Test2::Harness::UI::Schema::Result::Project",
        {project_id    => "project_id"},
        {is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION"},
    );
    __PACKAGE__->belongs_to(
        "user",
        "Test2::Harness::UI::Schema::Result::User",
        {user_id       => "user_id"},
        {is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION"},
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
        {data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16},
        "email_id",
        {data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16},
    );
    __PACKAGE__->set_primary_key("user_id");
    __PACKAGE__->add_unique_constraint("primary_email_email_id_key", ["email_id"]);
    __PACKAGE__->belongs_to(
        "email",
        "Test2::Harness::UI::Schema::Result::Email",
        {email_id      => "email_id"},
        {is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION"},
    );
    __PACKAGE__->belongs_to(
        "user",
        "Test2::Harness::UI::Schema::Result::User",
        {user_id       => "user_id"},
        {is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION"},
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
        {
            data_type     => "uuid",
            default_value => \"uuid_generate_v4()",
            is_nullable   => 0,
            size          => 16,
        },
        "name",
        {data_type => "citext", is_nullable => 0},
    );
    __PACKAGE__->set_primary_key("project_id");
    __PACKAGE__->add_unique_constraint("projects_name_key", ["name"]);
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
        {
            data_type     => "uuid",
            default_value => \"uuid_generate_v4()",
            is_nullable   => 0,
            size          => 16,
        },
        "run_ord",
        {
            data_type         => "bigint",
            is_auto_increment => 1,
            is_nullable       => 0,
            sequence          => "runs_run_ord_seq",
        },
        "user_id",
        {data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16},
        "status",
        {
            data_type     => "enum",
            default_value => "pending",
            extra         => {
                custom_type_name => "queue_status",
                list             => ["pending", "running", "complete", "broken", "canceled"],
            },
            is_nullable => 0,
        },
        "worker_id",
        {data_type => "text", is_nullable => 1},
        "error",
        {data_type => "text", is_nullable => 1},
        "project_id",
        {data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16},
        "pinned",
        {data_type => "boolean", default_value => \"false", is_nullable => 0},
        "added",
        {
            data_type     => "timestamp",
            default_value => \"current_timestamp",
            is_nullable   => 0,
            original      => {default_value => \"now()"},
        },
        "duration",
        {data_type => "text", is_nullable => 1},
        "mode",
        {
            data_type     => "enum",
            default_value => "qvfd",
            extra         => {
                custom_type_name => "run_modes",
                list             => ["summary", "qvfds", "qvfd", "qvf", "complete"],
            },
            is_nullable => 0,
        },
        "buffer",
        {
            data_type     => "enum",
            default_value => "job",
            extra         => {
                custom_type_name => "run_buffering",
                list             => ["none", "diag", "job", "run"],
            },
            is_nullable => 0,
        },
        "log_file_id",
        {data_type => "uuid", is_foreign_key => 1, is_nullable => 1, size => 16},
        "passed",
        {data_type => "integer", is_nullable => 1},
        "failed",
        {data_type => "integer", is_nullable => 1},
        "retried",
        {data_type => "integer", is_nullable => 1},
        "concurrency",
        {data_type => "integer", is_nullable => 1},
        "parameters",
        {data_type => "jsonb", is_nullable => 1},
    );
    __PACKAGE__->set_primary_key("run_id");
    __PACKAGE__->add_unique_constraint("runs_run_ord_key", ["run_ord"]);
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
            is_deferrable => 0,
            join_type     => "LEFT",
            on_delete     => "NO ACTION",
            on_update     => "NO ACTION",
        },
    );
    __PACKAGE__->belongs_to(
        "project",
        "Test2::Harness::UI::Schema::Result::Project",
        {project_id    => "project_id"},
        {is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION"},
    );
    __PACKAGE__->has_many(
        "run_fields",
        "Test2::Harness::UI::Schema::Result::RunField",
        {"foreign.run_id" => "self.run_id"},
        {cascade_copy     => 0, cascade_delete => 0},
    );
    __PACKAGE__->belongs_to(
        "user",
        "Test2::Harness::UI::Schema::Result::User",
        {user_id       => "user_id"},
        {is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION"},
    );

}

{
    package    #
        Test2::Harness::UI::Schema::Result::RunField;

    use base 'DBIx::Class::Core';
    __PACKAGE__->load_components(
        "InflateColumn::DateTime",
        "InflateColumn::Serializer",
        "InflateColumn::Serializer::JSON",
        "Tree::AdjacencyList",
        "UUIDColumns",
    );
    __PACKAGE__->table("run_fields");
    __PACKAGE__->add_columns(
        "run_field_id",
        {data_type => "uuid", is_nullable => 0, size => 16},
        "run_id",
        {data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16},
        "name",
        {data_type => "varchar", is_nullable => 0, size => 255},
        "data",
        {data_type => "jsonb", is_nullable => 1},
        "details",
        {data_type => "text", is_nullable => 1},
        "raw",
        {data_type => "text", is_nullable => 1},
        "link",
        {data_type => "text", is_nullable => 1},
    );
    __PACKAGE__->set_primary_key("run_field_id");
    __PACKAGE__->add_unique_constraint("run_fields_run_id_name_key", ["run_id", "name"]);
    __PACKAGE__->belongs_to(
        "run",
        "Test2::Harness::UI::Schema::Result::Run",
        {run_id        => "run_id"},
        {is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION"},
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
        {
            data_type     => "uuid",
            default_value => \"uuid_generate_v4()",
            is_nullable   => 0,
            size          => 16,
        },
        "active",
        {data_type => "boolean", default_value => \"true", is_nullable => 1},
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
        {
            data_type     => "uuid",
            default_value => \"uuid_generate_v4()",
            is_nullable   => 0,
            size          => 16,
        },
        "session_id",
        {data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16},
        "user_id",
        {data_type => "uuid", is_foreign_key => 1, is_nullable => 1, size => 16},
        "created",
        {
            data_type     => "timestamp",
            default_value => \"current_timestamp",
            is_nullable   => 0,
            original      => {default_value => \"now()"},
        },
        "accessed",
        {
            data_type     => "timestamp",
            default_value => \"current_timestamp",
            is_nullable   => 0,
            original      => {default_value => \"now()"},
        },
        "address",
        {data_type => "text", is_nullable => 0},
        "agent",
        {data_type => "text", is_nullable => 0},
    );
    __PACKAGE__->set_primary_key("session_host_id");
    __PACKAGE__->add_unique_constraint(
        "session_hosts_session_id_address_agent_key",
        ["session_id", "address", "agent"],
    );
    __PACKAGE__->belongs_to(
        "session",
        "Test2::Harness::UI::Schema::Result::Session",
        {session_id    => "session_id"},
        {is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION"},
    );
    __PACKAGE__->belongs_to(
        "user",
        "Test2::Harness::UI::Schema::Result::User",
        {user_id => "user_id"},
        {
            is_deferrable => 0,
            join_type     => "LEFT",
            on_delete     => "NO ACTION",
            on_update     => "NO ACTION",
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
        {
            data_type     => "uuid",
            default_value => \"uuid_generate_v4()",
            is_nullable   => 0,
            size          => 16,
        },
        "username",
        {data_type => "citext", is_nullable => 0},
        "pw_hash",
        {
            data_type     => "varchar",
            default_value => \"null",
            is_nullable   => 1,
            size          => 31,
        },
        "pw_salt",
        {
            data_type     => "varchar",
            default_value => \"null",
            is_nullable   => 1,
            size          => 22,
        },
        "realname",
        {data_type => "text", is_nullable => 1},
        "role",
        {
            data_type     => "enum",
            default_value => "user",
            extra         => {custom_type_name => "user_type", list => ["admin", "user"]},
            is_nullable   => 0,
        },
    );
    __PACKAGE__->set_primary_key("user_id");
    __PACKAGE__->add_unique_constraint("users_username_key", ["username"]);
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
