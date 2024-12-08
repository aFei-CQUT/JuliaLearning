# 参数化多项式结构体，支持不同类型的系数
struct Polyn{T}
    c::Vector{T}  # 存储多项式系数的向量
end

# 提取多项式系数
function coef(P::Polyn)
    return P.c
end

# 自定义多项式的显示格式
function Base.show(io::IO, P::Polyn)
    for (i, ci) in enumerate(P.c)
        if ci > 0
            if i == 1
                print(io, ci)  # 常数项
            else
                # 正系数项的处理
                print(io, " + ", ci == 1 ? "" : string(ci), "x^$(i-1)")
            end
        elseif ci < 0
            if i == 1
                print(io, ci)  # 负常数项
            else
                # 负系数项的处理
                print(io, "- ", ci == -1 ? "" : string(-ci), "x^$(i-1)")
            end
        end
    end
end

# 多项式加法
function Base.:+(P1::Polyn, P2::Polyn)
    c1 = P1.c
    c2 = P2.c
    n = max(length(c1), length(c2))
    
    # 逐项相加
    c = [get(c1, i, 0) + get(c2, i, 0) for i in 1:n]
    
    # 移除高次零系数
    while c[n] == 0
        pop!(c)
        n -= 1
    end
    
    Polyn(c)
end

# 多项式取负
function Base.:-(P::Polyn)
    Polyn(-P.c)
end

# 多项式减法
function Base.:-(P1::Polyn, P2::Polyn)
    P1 + (-P2)
end

# 数乘多项式（支持数字在左右两侧）
function Base.:*(α::Number, P::Polyn)
    Polyn(α .* P.c)
end

function Base.:*(P::Polyn, α::Number)
    Polyn(α .* P.c)
end

# 卷积计算（用于多项式乘法）
function convolve(a, b)
    na = length(a)
    nb = length(b)
    c = fill(zero(eltype(a)), na + nb - 1)
    
    for i = 0:(na-1)
        for j = 0:(nb-1)
            c[i+j+1] += a[i+1] * b[j+1]
        end
    end
    
    return c
end

# 多项式乘法
function Base.:*(P1::Polyn, P2::Polyn)
    c1 = P1.c
    c2 = P2.c
    c = convolve(c1, c2)
    Polyn(c)
end

# 多项式求值
function (p::Polyn)(x)
    Base.Math.evalpoly(x, p.c)
end


# 调用自定义函数
P1 = Polyn([1, 0, -1])  # 1 - x^2
P2 = Polyn([1, 1])      # 1 + x
result = P1 * P2        # 多项式乘法
println(result)         # 显示结果
println(P1(3))          # 求值：1 - 3^2
