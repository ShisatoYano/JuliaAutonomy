# categorical distribution sample

module CategoricalDistribution

  function main()
    # dice
    pi_ = [1/6, 1/6, 1/6, 1/6, 1/6, 1/6]
    c = [0, 1, 0, 0, 0, 0] # get 2, 1-of-K coding
    println(cat(c, pi_))
  end

  function cat(c, pi_)
    elems = [pik_^ck for (ck, pik_) in zip(c, pi_)]
    return prod(elems)
  end

end