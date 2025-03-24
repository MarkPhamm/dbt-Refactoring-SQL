# dbt-Refactoring-SQL
Refactoring SQL for Modularity
* Identify and explain the importance of SQL refactoring, specifically in the context of improving model maintainability.
* Analyze existing SQL scripts and identifying areas where cosmetic cleanups and CTE groupings can improve readability and maintainability.

# Steps to Refactoring Legacy Code

## 1. Migrating legacy code  
Create ```models\legacy``` and paste legacy code into the model

## 2. Implementing sources / translating hard-coded table references
Create ```source.yml``` and use the source function

## 3. Choosing a refactoring strategy
The following steps follow a "refactor along-side" strategy, leaving the   ```customer_orders.sql``` in place and untouched from this point forward. This approach will give us a legacy system to audit at the end

## 4. Cte groupings and cosmetic cleanups  

### use this guideline to refactor the cosmetics of your ```fct_customer_orders``` model:
* add whitespacing
* no lines over 80 characters
* lowercased keywords

### cte restructuring
refactor your code to follow this structure:

```sql
-- with statement
-- import ctes
-- logical ctes
-- final cte
-- simple select statement
``` 

a. add a ```with``` statement to the top of your ```fct_customer_orders``` model

b. add **import ctes** after the ```with``` statement for each source table that the query uses. ensure that subsequent from statements after the import ctes reference the named ctes rather than the ```{{ source() }}```.

c. move any subqueries into their own ctes, and then reference those ctes instead of the subquery.

d. wrap the remaining ```select``` statement in a cte and call this cte ```final```.

e. add a simple select statement at the end - ```select * from final```.



## 5 Centralizing transformations & splitting up models  
After you pulled out the subqueries into CTEs. Now you'll start removing redundant transformations and moving 1:1 transformations to the earliest CTEs that can handle them.

### 5.1 Staging models

**Move 1:1 transformations to CTEs**

1. Ignoring the import CTEs, identify where the staging CTEs are. These CTEs don't conduct any joins - notate above this section of CTEs with a comment that says ```-- staging```.

2. Identify where the marts CTEs are. These CTEs conduct joins - notate above this section of CTEs with a comment that says ```-- marts```.

3. Remove any redundant CTEs that conduct the same transformations on the same data sets. Replace all references to any removed CTEs with the proper references.

4. In the marts area, look at each field and identify the transformations that answer Yes to both of these questions:
   * Can this transformation be done using one data set?
   * Is this transformation done on a field whose value is not due to a join?
   * **For example:** ```case when data_set.status is null looks``` like it can be done using one data set, but if the status is null because the row wasn't joined with other data, then doing this earlier than where the join occurs will result in incorrect calculations.

   Move these transformations to the appropriate CTE under the ```-- staging``` section of code. Ensure that when you move these, you are:

   * Removing redundant transformations
   * Re-referencing the CTE and field names correctly
   * Giving good names to fields that don't have a good name established


### 5.2 CTEs or Intermediate Models  

### 5.3 Final Model  

## 6. Auditing  


## Migrating legacy code
 
