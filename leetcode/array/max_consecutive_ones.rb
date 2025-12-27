def find_max_consecutive_ones(nums)
    return 0 if nums.all?(&:zero?)
    score = 1
    hight_score = 1
    root_pointer = 0
    nums.each_with_index {
      next if _2 == 0

      if _1 == 1 && nums[root_pointer] == _1
        score += 1
        root_pointer += 1
        if score > hight_score
          hight_score = score
        end
      else
        root_pointer = _2 
        score = 1
      end
    }

    hight_score
end

pp find_max_consecutive_ones([1,1,0,1,1,1])
pp find_max_consecutive_ones([1,0,1,1,0,1])
