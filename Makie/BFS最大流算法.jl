using LinearAlgebra

# 参数初始化
# 逻辑思路：
# 1. 初始化容量矩阵 u 和流量矩阵 f，矩阵 u 定义每条边的容量，f 定义当前的流量。
# 2. 使用宽度优先搜索 (BFS) 找到增广路径，通过前向边和反向边更新流量。
# 3. 循环执行 BFS，直到无法找到增广路径，最终 f 矩阵即为最大流矩阵。

M = 1000  # 初始化最大流的无穷大值（一个极大值）

# u 为容量矩阵
u = zeros(Int, 5, 6)  # 初始化容量矩阵为 5x6 的零矩阵
u[1, 2] = 5;
u[1, 3] = 6;  # 顶点 1 到顶点 2 和 3 的容量
u[2, 4] = 4;  # 顶点 2 到顶点 4 的容量
u[3, 2] = 3;
u[3, 4] = 4;
u[3, 5] = 5;  # 顶点 3 的容量设置
u[4, 5] = 6;
u[4, 6] = 6;  # 顶点 4 的容量设置
u[5, 6] = 8;  # 顶点 5 到顶点 6 的容量

# f 为初始流量矩阵
f = zeros(Int, 5, 6)  # 初始化流量矩阵为 5x6 的零矩阵
f[1, 2] = 3;
f[1, 3] = 6;  # 设置初始流量
f[2, 4] = 4;
f[3, 2] = 1;
f[3, 4] = 2;
f[3, 5] = 3;
f[4, 5] = 2;
f[4, 6] = 4;
f[5, 6] = 5;

n = size(u, 1)  # 获取顶点数量
list = Int[]  # 用于存储 BFS 队列
maxf = zeros(Int, n)  # 用于记录每个顶点的最大可增广流量
maxf[end] = 1  # 初始化结束节点的流量标记

# 主循环：寻找增广路径并更新流量
while maxf[end] > 0
    maxf .= 0  # 重置最大流量数组
    pred = zeros(Int, n)  # 初始化前驱节点数组
    list = [1]  # BFS 队列起点为节点 1
    record = copy(list)  # 记录已访问节点
    maxf[1] = M  # 起始节点的初始流量为无穷大

    # BFS 寻找增广路径
    while !isempty(list) && maxf[end] == 0
        flag = list[1]  # 取出队列的第一个节点
        list = list[2:end]  # 更新队列

        # 前向边：检查未满流量的边
        index1 = findall(x -> x != 0, u[flag, :])  # 查找节点 flag 的所有邻接点
        label1 = filter(x -> u[flag, x] - f[flag, x] != 0, index1)  # 找到仍有剩余容量的边
        label1 = setdiff(label1, record)  # 排除已访问的节点

        append!(list, label1)  # 将找到的节点加入队列
        pred[label1[findall(x -> pred[x] == 0, label1)]] .= flag  # 设置前驱节点
        maxf[label1] .= min.(maxf[flag], u[flag, label1] .- f[flag, label1])  # 更新最大流量
        record = union(record, label1)  # 更新已访问节点记录

        # 反向边：检查仍有流量的边
        label2 = findall(x -> f[x, flag] != 0, 1:n)  # 找到流量不为 0 的反向边
        label2 = setdiff(label2, record)  # 排除已访问的节点

        append!(list, label2)  # 将找到的节点加入队列
        pred[label2[findall(x -> pred[x] == 0, label2)]] .= -flag  # 设置前驱节点（负值表示反向边）
        maxf[label2] .= min.(maxf[flag], f[label2, flag])  # 更新最大流量
        record = union(record, label2)  # 更新已访问节点记录
    end

    # 如果找到增广路径，更新流量矩阵
    if maxf[end] > 0
        v2 = n  # 结束节点
        v1 = pred[v2]  # 前驱节点

        while v2 != 1  # 从结束节点回溯到起点
            if v1 > 0  # 前向边
                f[v1, v2] += maxf[end]
            else  # 反向边
                v1 = abs(v1)
                f[v2, v1] -= maxf[end]
            end

            v2 = v1  # 更新当前节点
            v1 = pred[v2]  # 更新前驱节点
        end
    end
end

# 最后的 f 即为最大流矩阵
println("最大流矩阵 f:")
@show f
