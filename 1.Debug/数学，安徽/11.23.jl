using TyBase
using TyMath

function Markov(A)
    n = size(A, 1)
    
    # 打印矩阵的行和，帮助调试
    println("A 的行和: ", sum(A, dims=2))

    # 判断矩阵 A 是否是一个合法的马尔可夫转移矩阵（每行和为1）
    if all(abs.(sum(A, dims=2) .- 1) .< 1e-6)
        # 求解 x'A = x'
        eigenvals, eigenvecs = eigen(A')
        x = real(eigenvecs[:, findall(x -> isapprox(x, 1), eigenvals)])
        
        # 归一化
        x = x ./ sum(x)
        
        println("解 x: ", x)

        # 检查平稳分布条件
        if isapprox(sum(x), 1, atol=1e-6) && all(x .>= 0)
            println("存在平稳分布: ", x)
        else
            println("没有满足条件的平稳分布。")
        end
    else
        println("A 不是一个合法的转移矩阵。")
    end
end

A = [1/3 2/3 0; 1/3 0 2/3; 0 1/3 2/3]
Markov(A)
