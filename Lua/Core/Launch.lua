---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zheng.
--- DateTime: 2019/5/18 23:09
---

--设置随机种子 每次启动随机数都不一样
math.randomseed(tostring(os.time()):reverse():sub(1, 6))
vmgr:Init()
vmgr:LoadView(ViewConfig.World)