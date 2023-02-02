use utf8;
package Test2::Harness::UI::Schema::Result::Resource;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components(
  "InflateColumn::DateTime",
  "InflateColumn::Serializer",
  "InflateColumn::Serializer::JSON",
  "Tree::AdjacencyList",
  "UUIDColumns",
);
__PACKAGE__->table("resources");
__PACKAGE__->add_columns(
  "resource_id",
  {
    data_type => "uuid",
    default_value => \"uuid_generate_v4()",
    is_nullable => 0,
    size => 16,
  },
  "run_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 1, size => 16 },
  "host_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 1, size => 16 },
  "global",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "module",
  { data_type => "varchar", is_nullable => 0, size => 512 },
  "stamp",
  { data_type => "timestamp", is_nullable => 0 },
  "data",
  { data_type => "jsonb", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("resource_id");
__PACKAGE__->belongs_to(
  "host",
  "Test2::Harness::UI::Schema::Result::Host",
  { host_id => "host_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);
__PACKAGE__->belongs_to(
  "run",
  "Test2::Harness::UI::Schema::Result::Run",
  { run_id => "run_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2023-01-23 09:08:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8494Q7Gvb7S3Mz5fiHszow


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
