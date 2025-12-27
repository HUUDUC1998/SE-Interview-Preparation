def shuffle(nums, n)
    arr = []

    nums.each_with_index { 
        next if _2 >= n
        arr << [_1, nums[n + _2]] 
    }

    arr.flatten.compact
end

puts shuffle([2,5,1,3,4,7], 3) == [2,3,5,4,1,7]
