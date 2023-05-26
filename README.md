# URL Shortener
This application is designed to provide a simple and efficient way to shorten URLs. It has been developed using the Ruby on Rails framework and incorporates RESTful API endpoints. The project was undertaken as part of an assignment for The nami.ai Team.

## ***Features***
* Built with Ruby on Rails
* Utilizes RSpec for testing
* PostgreSQL database
* Implements JWT and Devise for authorization
* Utilizes SecureRandom gem for generating shorten URL

## ***Potential Attack Vectors***
While developing this application, I have considered various potential attack vectors and identified measures to enhance security in future versions. Although these measures have not been implemented in the current version, they can be considered for future updates. The main security measure in the current version is the utilization of JSON Web Tokens (JWT) for authentication.
1. **Unauthorized Access:** To address unauthorized access, the application incorporates JWT for authentication. This ensures that only authenticated users with valid tokens can access the endpoints and perform actions.
2. **Request Rate Limiting:**  In future versions, it is advisable to implement rate limiting to prevent abuse or denial-of-service attacks. This can be achieved by monitoring the number of requests made by a user within a specified time period and enforcing limits accordingly.
3. **DDoS Attacks:** If a user system is not desired, we can employ IP-based request limiting to prevent Distributed Denial-of-Service (DDoS) attacks. This can be achieved by utilizing middleware or implementing IP-based restrictions within the controllers. By limiting the number of requests from a single IP address within a specified time frame, we can mitigate the impact of DDoS attacks.

## ***Scaling Up Considerations***
Scaling up an application requires careful consideration of various factors to ensure optimal performance and availability. Here are some key areas to consider when scaling up this application:

### 1. **Database**
When transitioning to a production environment and preparing to handle a large volume of data, it's important to carefully consider the database solution. Anticipating the potential for billions of records and the need for distributed databases across multiple servers to handle increased load, a NoSQL database like MongoDB is recommended. NoSQL databases provide the flexibility and scalability required for such scenarios, allowing for efficient storage and retrieval of data. However, it's important to note that NoSQL databases typically sacrifice some of the ACID guarantees provided by traditional relational databases (RDBMS) due to their eventual consistency model.

One advantage of NoSQL databases is the ability to scale up vertically by increasing the resources of a single server. Vertical scaling involves upgrading the server's hardware, such as adding more RAM, increasing CPU capacity, or improving disk performance. This approach allows the database to handle larger workloads and process more data without the need for complex distributed setups. Vertical scaling can be a cost-effective solution, especially in scenarios where the application's growth can be accommodated by a single, more powerful server.

To address the challenges of eventual consistency, a solution will be described in the encoding approach section, which will ensure the uniqueness of encoded URLs. In the next section the solution to maintain uniqueness will be discussed in detail.

By considering these factors and adopting the suggested NoSQL database solution, you can effectively handle the large volume of data, distribute the workload across multiple servers, and lay the foundation for a scalable and robust application.

### 2. **Encoding Approach**
To ensure the uniqueness of encoded URLs and address the challenges of eventual consistency, a Key Generation Service (KGS) can be implemented. The KGS generates unique keys for the short links, ensuring that no two links have the same identifier.

Here is a suggested approach for the Key Generation Service (KGS):

1. Implement a KGS that generates random seven-letter strings beforehand and stores them in a database (e.g., key-DB).
2. Whenever a URL needs to be shortened, the KGS selects one of the pre-generated keys from the key-DB.
3. To prevent duplication, mark the selected key as used in the database immediately.
4. To handle concurrency, the KGS can use two tables in the database: one for unused keys and another for used keys.
5. As soon as the KGS assigns a key to a server, it moves that key to the used keys table.
6. The KGS can keep a portion of the keys in memory for quick access and assign them to servers when requested.
7. It is essential for the KGS to synchronize or obtain locks on the data structure holding the keys to prevent multiple servers from receiving the same key.
8. To mitigate the single point of failure, consider having a standby replica of the KGS that can take over generating and providing keys if the primary server fails.

By implementing this approach, you can ensure the uniqueness of short links across multiple servers and avoid collisions. Additionally, caching a subset of keys on application servers can help improve performance, but it's important to handle the scenario where an application server dies before consuming all the keys.

### 3. **Link Expiration Management**
To effectively manage link expiration, it is beneficial to implement a system that periodically collects and handles expired links. This ensures that expired links are promptly identified and removed from the system, maintaining the accuracy and efficiency of the application.

One approach is to schedule background tasks or jobs that run at regular intervals to check the validity of the links. These tasks can query the database for expired links based on their expiration timestamps and perform the necessary actions, such as marking them as expired or removing them from the database.

Alternatively, we can implement a mechanism where the validity of a link is checked upon each request. When a user accesses a shortened URL, the system can verify if the link has expired before redirecting them. If the link is found to be expired, it can be immediately deleted or handled according to the defined expiration policy.

By implementing a system to collect and manage expired links, we ensure that the application maintains a clean and relevant database. This not only helps in optimizing storage and performance but also improves the overall user experience by preventing users from accessing expired or outdated content.

The specific implementation details of the link expiration management system may vary based on the application's requirements and the chosen technologies. It is important to consider factors such as performance impact, frequency of expiration checks, and the handling of expired links to design an efficient and reliable solution.

### 4. **Caching**
Implementing a caching layer can significantly improve the performance and scalability of the application. By caching frequently accessed data, the application can reduce the load on the database and improve response times.

Caching involves storing frequently accessed data in a fast-access memory layer. This allows subsequent requests for the same data to be served directly from the cache, eliminating the need to query the underlying data source. By avoiding repeated database queries, the application can respond more quickly to user requests.

When implementing caching, it is important to consider cache invalidation strategies. This ensures that cached data remains up to date and reflects any changes made to the underlying data source. Depending on the application's requirements, different cache invalidation strategies such as time-based expiration or explicit invalidation can be employed.

By incorporating a caching layer into the application architecture, we can achieve improved performance, reduced database load, and enhanced scalability, leading to a better user experience.

### 5. **Application Servers**
When considering the scalability of the application, it is important to design the architecture with the ability to accommodate multiple application servers. By deploying multiple servers, we can distribute the workload and handle increased traffic effectively.

One advantage of this system design is its ease of implementation. With the use of technologies like load balancers, it becomes straightforward to add new servers to the infrastructure. This allows for horizontal scaling, where additional servers can be added to handle growing user demands.

Furthermore, implementing a caching layer on each application server can greatly enhance the system's performance. By caching frequently accessed data directly on the server, we can reduce the need for repeated database queries and improve response times. This can lead to better overall system performance and a smoother user experience.

By leveraging multiple application servers and incorporating caching mechanisms, we can create a scalable system that can handle increased traffic and provide optimal performance. This design consideration allows for easy scalability and improved responsiveness, ensuring that the application can grow seamlessly as user demands increase.

## ***Installation And Usage***
This application is made by Docker. For more detail visit the [INSTALLATION.md](./INSTALLATION.md)