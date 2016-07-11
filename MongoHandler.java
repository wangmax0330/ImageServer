package four;

import java.net.UnknownHostException;

import com.mongodb.BasicDBObject;
import com.mongodb.DB; 
import com.mongodb.DBObject;
import com.mongodb.Mongo;
import com.mongodb.MongoException;
import com.mongodb.DBCollection;


public class MongoHandler {
	public static void main(String[] args) {  
        Mongo m = null;  
        DB db = null;  
        DBCollection dbCollection;
        try {  
            //Mongo(p1, p2):p1=>IP地址     p2=>端口  
            m = new Mongo("192.168.152.130", 27017);  
            //根据mongodb数据库的名称获取mongodb对象  
            db=m.getDB("users");
            //判断是否存在集合
            boolean b=db.collectionExists("user");
            System.out.println("before是否存在集合:"+b);
            dbCollection = db.getCollection("user");
            
            DBObject arr = new BasicDBObject();
            arr.put("city", "cq");
            arr.put("age", "23");
            
			 //将arr中的数据插入数据库
            dbCollection.save(arr);
            //dbCollection.insert(arr);  用insert也可以
            long count=dbCollection.count();
            System.out.println("总记录数是:"+count);
     
          
        } catch (UnknownHostException e) {  
            e.printStackTrace();  
        } catch (MongoException e) {  
            e.printStackTrace();  
        }  
        //mongodb连接关闭  
        finally{  
            if (null != m) {  
                if (null != db) {  
                    // 结束Mongo数据库的事务请求  
                    try {  
                        db.requestDone();  
                    } catch(Exception e) {  
                        e.printStackTrace();  
                    }  
                }  
                try  
                {  
                    m.close();  
                } catch(Exception e1) {  
                    e1.printStackTrace();  
                }  
                m = null;  
            }  
        }  
    }

}
