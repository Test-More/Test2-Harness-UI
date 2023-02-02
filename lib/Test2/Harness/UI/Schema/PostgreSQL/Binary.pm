use utf8;
package Test2::Harness::UI::Schema::Result::Binary;

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
__PACKAGE__->table("binaries");
__PACKAGE__->add_columns(
  "binary_id",
  { data_type => "uuid", is_nullable => 0, size => 16 },
  "event_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "filename",
  { data_type => "varchar", is_nullable => 0, size => 512 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "is_image",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "data",
  { data_type => "bytea", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("binary_id");
__PACKAGE__->belongs_to(
  "event",
  "Test2::Harness::UI::Schema::Result::Event",
  { event_id => "event_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2023-01-23 09:08:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SG1deLWicoT/plrw3L/2ww


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
