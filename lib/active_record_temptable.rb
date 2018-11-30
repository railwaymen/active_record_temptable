# frozen_string_literal: true

require "active_record_temptable/version"
require 'active_record'

module ActiveRecordTemptable
  extend self

  def with_temptable(relation, indexes = [], table_name='activerecord_temptable_records')
    ActiveRecord::Base.connection.transaction do
    begin
      create_table(relation, table_name)
      create_indexes(table_name, indexes) if indexes.any?
      klass = relation.klass
      yield klass.unscoped.from("#{table_name} AS #{klass.table_name}") if block_given?
    ensure
      drop_table(table_name)
    end
    end
  end

  def create_table(relation, table_name)
    ActiveRecord::Base.connection.execute(new_table_command(relation, table_name))
  end

  def create_indexes(table_name, indexes)
    indexes.each do |fields, options|
      ActiveRecord::Base.connection.add_index(table_name, fields, options || {})
    end
  end

  def drop_table(table_name)
    ActiveRecord::Base.connection.execute(drop_table_command(table_name))
  end

  private

  def new_table_command(relation, table_name)
    "CREATE TEMPORARY TABLE #{table_name} AS #{relation.to_sql}"
  end

  def drop_table_command(table_name)
    "DROP TABLE IF EXISTS #{table_name}"
  end
end
