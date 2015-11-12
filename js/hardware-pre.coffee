makeMemory = (size) ->
    size = size || 256
    _.fill(Array(size), 0)
