using DataFrames

da0 = DataFrame(
           name = ["张三", "李四", "王五", "赵六"],
           age = [33, 42, missing, 51],
           sex = ["M", "F", "M", "M"])

@show da0