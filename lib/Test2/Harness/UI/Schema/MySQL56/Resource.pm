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
  { data_type => "char", is_nullable => 0, size => 36 },
  "resource_batch_id",
  { data_type => "char", is_foreign_key => 1, is_nullable => 0, size => 36 },
  "batch_ord",
  { data_type => "integer", is_nullable => 0 },
  "module",
  { data_type => "varchar", is_nullable => 0, size => 512 },
  "data",
  { data_type => "longtext", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("resource_id");
__PACKAGE__->add_unique_constraint("resource_batch_id", ["resource_batch_id", "batch_ord"]);
__PACKAGE__->belongs_to(
  "resource_batch",
  "Test2::Harness::UI::Schema::Result::ResourceBatch",
  { resource_batch_id => "resource_batch_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2023-02-15 17:15:55
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NI0cSJXrLye9Pe/USJ+sTw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;