NTCoreData
===========

NTCoreData is small library that helps perform saves and fetches asynchronously in Core Data. Each save and fetch is done asynchronously. All heavy lifting regarding managing threads and context is done by NTDatabase class.

This library was inspiered by this [article](http://floriankugler.com/blog/2013/4/29/concurrent-core-data-stack-performance-shootout) by Florian Kugler. For now it implements following stack in core data:

![image](http://static.squarespace.com/static/5159eb3de4b01cd3b022715d/t/517e6219e4b0f470ac92f51a/1367237146374/stack%202.png?format=500w)

We are going to implement last stack later on without changing class interface. So stay tuned.

Example
-------
You can look at the example app to see how to perform fetches, saves, updates. Also please read documentation provided in class to fully understand how this works.

TODO
----

* Implement better examples;
* Add to pods;
* Implement Stack#3 from articel.

Authors and Contributors
------------------------

Project is developed by [Nomtek](http://nomtek.com).	

License
-------
NTCoreData is licensed under the [Apache 2.0 License.](http://www.apache.org/licenses/LICENSE-2.0.html)
