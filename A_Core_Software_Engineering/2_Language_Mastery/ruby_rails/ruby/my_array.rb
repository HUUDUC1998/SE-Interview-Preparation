class MyArray 
  attr_reader :length

  def initialize(*elements)
    @elements = elements
    @length = count_elements(elements)
  end

  def size
    length
  end

  def is_empty?
    length == 0
  end

  def at(index)
    return "index out of boudary" if index >= length

    hash = {}
    n = 0

    for item in elements
      hash[n] = item
      n += 1
    end

    hash[index]
  end

  private 

  attr_reader :elements

  def count_elements(elements)
    count = 0

    for e in elements 
      count += 1
    end

    count
  end
end


# Tests
require 'minitest/autorun'

describe MyArray do
  describe "length when 0 elements" do
    before do
      @my_array = MyArray.new()
    end
    it do
      @my_array.length.must_equal 0
    end
  end

  describe "length when 1 elements" do
    before do
      @my_array = MyArray.new(1)
    end
    it do
      @my_array.length.must_equal 1
    end
  end

  describe "length when 2 elements" do
    before do
      @my_array = MyArray.new(1,2)
    end
    it do
      @my_array.length.must_equal 2
    end
  end

  describe "#size when 0 elements" do
    before do
      @my_array = MyArray.new()
    end
    it do
      @my_array.size.must_equal 0
    end
  end

  describe "#size when 1 elements" do
    before do
      @my_array = MyArray.new(1)
    end
    it do
      @my_array.size.must_equal 1
    end
  end

  describe "#size when 2 elements" do
    before do
      @my_array = MyArray.new(1,2)
    end
    it do
      @my_array.size.must_equal 2
    end
  end

  describe "#is_empty? when has 0 item" do
    before do
      @my_array = MyArray.new()
    end

    it do
      @my_array.is_empty?.must_equal true
    end
  end

  describe "#is_empty? when has 1 item" do
    before do
      @my_array = MyArray.new(1)
    end

    it do
      @my_array.is_empty?.must_equal false
    end
  end

  describe "at()" do
    before do
      @my_array = MyArray.new(1,2)
    end

    describe "with valid index" do
      it do 
        @my_array.at(0).must_equal 1
      end
    end

    describe "with index out of boudary" do
      it do 
        @my_array.at(2).must_equal "index out of boudary"
      end
    end
  end
end
