# frozen_string_literal: true

require "active_record_temptable/version"
require 'active_record'

module ActiveRecordTemptable
  extend self

  def with_temptable(relation, indexes = [], table_name='activerecord_temptable_records')
    ActiveRecord::Base.connection_pool.with_connection do |connection|
      connection.transaction do
      begin
        create_table(connection, relation, table_name)
        create_indexes(connection, table_name, indexes) if indexes.any?
        klass = relation.klass
        yield klass.unscoped.from("#{table_name} AS #{klass.table_name}") if block_given?
      ensure
        drop_table(connection, table_name)
      end
      end
    end
  end

  def create_table(connection, relation, table_name)
    connection.execute(new_table_command(relation, table_name))
  end

  def create_indexes(connection, table_name, indexes)
    indexes.each do |fields, options|
      connection.add_index(table_name, fields, options || {})
    end
  end

  def drop_table(connection, table_name)
    connection.execute(drop_table_command(table_name))
  end

  private

  def new_table_command(relation, table_name)
    "CREATE TEMPORARY TABLE #{table_name} AS #{relation.to_sql}"
  end

  def drop_table_command(table_name)
    "DROP TABLE IF EXISTS #{table_name}"
  end
end
