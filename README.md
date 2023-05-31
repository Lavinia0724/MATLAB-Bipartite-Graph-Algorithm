# LAVI's MATLAB Bipartite Graph Algorithm Side Project
###### tags: `Side Project` `MATLAB` `LAVI` `2023` 

## Information
### Method 1: Hungarian Algorithm
- 二分圖最大匹配 - 匈牙利演算法
- 目的：盡可能讓所有 Process 都有 Edge Server 匹配

#### Diagram
1. 模擬 Process 與 Edge Server 連線狀況
  ![](https://hackmd.io/_uploads/HJtoTTZ8n.png)

2. 簡易模擬流程圖
  ![](https://hackmd.io/_uploads/HkCa8hmI3.png=500x)

### Method 2: KM 演算法 (Kuhn-Munkres Algorithm)
- 二分圖最大權重匹配 - KM 演算法
- 目的：依照 Process 對 Edge Server 的優先權分配，盡可能讓所有 Process 都以較高的優先權進行匹配

#### Diagram
1. 模擬 Process 與 Edge Server 連線狀況
![](https://hackmd.io/_uploads/ryYov3X8n.png)
2. 簡易模擬流程圖
![](https://hackmd.io/_uploads/Sy7K037Un.png)

## Reference
- [使用 MATLAB 對二分圖進行匹配（匈牙利算法）](https://blog.csdn.net/john_xia/article/details/117025174)
- [KM 算法原理+證明](https://blog.csdn.net/qq_25379821/article/details/83750678)
- [子傑學長的 FJCU CPC 訓練網 - 二分圖匹配](https://fjuonlinejudge.github.io/Training/graph/bigraph/#_5)
- [帶權二部圖匹配（KM 算法）講解及 MATLAB 實現](https://blog.csdn.net/john_xia/article/details/117247980)
