# frozen_string_literal: true

require 'active_record_temptable/version'
require 'active_record'

module ActiveRecordTemptable
  extend self

  DEFAULT_TABLE_NAME = 'activerecord_temptable_records'.freeze


  # Yields provided relation loaded in temporary table
  #
  # @param relation [ActiveRecord::Relation]
  # @param indexes [Array] add_index will be called for every element in indexes
  # @param table_name [String] name of table
  # @return [void]
  def with_temptable(relation, indexes = [], table_name = DEFAULT_TABLE_NAME)
    ActiveRecord::Base.connection_pool.with_connection do |connection|
      connection.transaction do
        begin
          connection.create_table(table_name, temporary: true, as: relation.to_sql)
          create_indexes(connection, table_name, indexes)
          klass = relation.klass
          yield klass.unscoped.from("#{table_name} AS #{klass.table_name}") if block_given?
        ensure
          connection.drop_table(table_name, if_exists: true)
        end
      end
    end
  end

  # Calls add_index for every element in array
  #
  # @param connection [ActiveRecord::ConnectionAdapters]
  # @param table_name [String]
  # @param indexes [Array]
  # @return [void]
  def create_indexes(connection, table_name, indexes)
    indexes.each do |fields, options|
      connection.add_index(table_name, fields, options || {})
    end
  end
end
