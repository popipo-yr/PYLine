
---
#PYLine
-------------

> 在项目中很多地方需要在视图中画一些有规则线条,如下划线等.则创建了这个UIView的扩展来做这个操作  
    

####示例:  
![image](https://github.com/popipo-yr/PYLine/blob/master/Demo/1.png)



### 下载安装
目前没有支持cocospods,下载PYLine加入头文件就可使用

###使用方法
>一般方法: 创建**PYLineInfo**实例,通过**addLineInfo:**添加到指定view.  
特殊方法: **UIView_Line+Addition**中做了一些简化操作来添加特定点的线条,单需要配置宏来控制线条

### 注意事项
**UIView-corner**扩展谨慎使用,没有在实际项目中进行长时间运行测试,请忽略.
