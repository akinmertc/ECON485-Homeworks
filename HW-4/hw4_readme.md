# ECON485 Homework 4 - NoSQL Research Paper

## Overview
This homework explores NoSQL database technologies as complementary solutions to relational databases in course registration systems. Through research-based analysis, the paper examines three operational challenges where NoSQL databases (Redis, MongoDB) provide distinct advantages.

## Files
- `HW-4.pdf` - Complete research paper (9-10 pages)
- `hw4_readme.md` - This file

## Paper Structure

### Main Sections

1. **Introduction** (~1 page)
   - Context: Scalability challenges in course registration systems
   - Overview of NoSQL database types
   - Polyglot persistence architecture concept

2. **Task 1: Seat Availability Lookups Using Redis** (~2 pages)
   - Problem: Expensive SQL aggregation queries under high concurrency
   - Solution: Redis in-memory key-value store
   - Topics covered:
     - Atomic increment/decrement operations
     - Cache invalidation strategies
     - Write-through caching pattern
     - When Redis is preferred over SQL
     - Operational risks and limitations
   - Real-world examples: Twitter, GitHub, Stack Overflow

3. **Task 2: Prerequisite Eligibility Caching** (~2 pages)
   - Problem: Repeated complex JOIN operations
   - Solutions: Redis (simple) vs. MongoDB (rich data)
   - Topics covered:
     - Key-value vs. document store trade-offs
     - Cache population strategies (lazy vs. eager)
     - Time-based and event-based invalidation
     - Consistency challenges and solutions
   - Case study: University prerequisite caching (92% hit rate)

4. **Task 3: Historical Action Logging Using MongoDB** (~2 pages)
   - Problem: Variable-structure data in rigid SQL schemas
   - Solution: MongoDB document database
   - Topics covered:
     - Schema flexibility and evolutionary design
     - Append-heavy workload optimization
     - Indexing nested documents
     - Comparison with relational approach
     - When to use document databases
   - Case studies: LinkedIn, University of Michigan, Pinterest

5. **Conclusion** (~1 page)
   - Summary of findings
   - Polyglot persistence architecture recommendations
   - Future research directions

6. **References** (~1 page)
   - 15+ academic and industry sources
   - Proper citations (academic format)

## Key Concepts Covered

### NoSQL Database Types
- **Key-Value Stores** (Redis)
  - In-memory data storage
  - Atomic operations
  - Sub-millisecond latency
  - Use cases: Caching, session storage, counters

- **Document Databases** (MongoDB)
  - JSON-like document structure
  - Schema flexibility
  - Nested data support
  - Use cases: Historical logs, variable-structure data, analytics

### Performance Characteristics

| **Metric**                    | **SQL**        | **Redis**      | **MongoDB**    |
|-------------------------------|----------------|----------------|----------------|
| Read Latency                  | 10-100ms       | <1ms           | 1-10ms         |
| Write Throughput              | 1-10K ops/sec  | 100K+ ops/sec  | 10-50K ops/sec |
| Consistency                   | Strong ACID    | Atomic ops     | Eventual       |
| Schema Flexibility            | Rigid          | N/A            | Very flexible  |
| Query Complexity              | Very high      | Simple K-V     | Moderate       |

### Architecture Patterns

**Polyglot Persistence (example):**
- PostgreSQL (transactional data): Students, Courses, Registrations, Grades
- Redis (hot cache): Seat availability, Session data, Eligibility cache
- MongoDB (historical data): Action logs, Audit trails, Analytics data


## Research Methodology

### Sources Used

**Academic Papers:**
- Khan et al. (2019) - Performance analysis of hybrid architectures
- Chen & Kumar (2021) - University of Michigan case study
- Kleppmann (2017) - Designing Data-Intensive Applications
- Cattell (2011) - Scalable SQL and NoSQL data stores

**Industry Documentation:**
- Redis Labs official documentation
- MongoDB manual and best practices
- Twitter Engineering blog (caching strategies)
- GitHub Engineering blog (rate limiting)

**Books:**
- Fowler & Sadalage (2012) - NoSQL Distilled
- Kleppmann (2017) - Data-Intensive Applications

### Research Questions Addressed

1. **When should Redis be used over SQL for caching?**
   - High read-to-write ratio (>90% reads)
   - Sub-10ms latency requirements
   - Concentrated traffic loads (peak periods)
   - Brief inconsistencies acceptable

2. **Key-value vs. document stores for eligibility caching?**
   - Simple binary results -> Redis
   - Rich prerequisite details -> MongoDB
   - Ultra-low latency -> Redis
   - Complex queries on cached data -> MongoDB

3. **Why document databases for historical logging?**
   - Variable action structures (overrides, approvals, conflicts)
   - Schema evolution without downtime
   - Append-heavy workloads (10K+ writes/sec)
   - Temporal queries common

## Key Findings

### Performance Improvements
- **Seat availability queries:** 45ms -> 0.8ms (94% reduction)
- **Database CPU utilization:** 67% reduction during peak loads
- **Cache hit rates:** 92% for prerequisite checks
- **Write throughput:** 10x improvement for action logging

### Trade-offs Identified
- **Consistency:** NoSQL often provides eventual consistency vs. SQL's strong ACID
- **Complexity:** Multiple database systems increase operational overhead
- **Expertise:** Requires team knowledge of cache invalidation, document modeling
- **Cost:** Additional infrastructure (Redis servers, MongoDB clusters)

### When to Use What

**Use SQL when:**
- Strong consistency mandatory
- Complex joins across entities
- ACID transactions required
- Deep SQL expertise available

**Use Redis when:**
- Very high read volume
- Sub-millisecond latency needed
- Simple key-value lookups
- Temporary/ephemeral data

**Use MongoDB when:**
- Variable data structures
- Schema evolution frequent
- Append-heavy writes
- Nested/hierarchical data

## Real-World Case Studies Analyzed

1. **Twitter Timeline Caching**
   - Redis for tweet timelines
   - 90% MySQL load reduction
   - Source: Krikorian (2010)

2. **University of Michigan Registration History**
   - Oracle -> MongoDB migration
   - 83% query performance improvement
   - 40% storage cost reduction
   - Source: Chen & Kumar (2021)

3. **LinkedIn Activity Logging**
   - Billions of events annually
   - 70% write latency reduction
   - Source: Weiner et al. (2012)

4. **Pinterest Activity Logs**
   - 150B+ actions/year
   - MySQL -> HBase migration
   - 300ms -> 10ms write latency
   - Source: Venkataramani et al. (2016)

## Academic Writing Standards

### Citation Format
- Academic style (APA/IEEE)
- 15+ credible sources cited
- In-text citations throughout
- Full reference list at end

### Structure
- Formal academic tone
- Clear section organization
- Logical flow of arguments
- Evidence-based claims

### Length
- Abstract: 150-200 words
- Introduction: ~1 page
- Each task: ~2 pages
- Conclusion: ~1 page
- Total: 9-10 pages (excluding references)

## AI Usage Disclosure

### Claude AI Assistance
Claude AI was used to assist with:
- Literature review and source identification
- Technical concept explanations
- Paper structure and organization
- Writing clarity and grammar
- Formatting and citations

### Student Contribution
All of the following were student-directed:
- Research question formulation
- Source selection and evaluation
- Critical analysis and synthesis
- Trade-off evaluation
- Conclusions and recommendations

**Note:** All content was reviewed, edited, and approved. AI was used as a research and writing assistant, not as the primary author.

## Connection to Course Content

This homework builds on previous assignments:

**HW1 (Database Design):**
- Identified entities and relationships
- Established baseline SQL architecture

**HW2 (SQL Implementation):**
- Implemented tables and queries
- Experienced JOIN complexity firsthand

**HW3 (Advanced Queries):**
- Complex multi-table JOINs
- Performance considerations
- Query optimization needs

**HW4 (NoSQL Research):**
- Explores alternatives to relational model
- Evaluates when NoSQL complements SQL
- Prepares for real-world polyglot architectures

## Learning Outcomes

After completing this research paper, students should understand:

1. **When relational databases have limitations**
   - High concurrency scenarios
   - Schema evolution requirements
   - Append-heavy workloads

2. **NoSQL database characteristics**
   - Key-value stores (Redis)
   - Document databases (MongoDB)
   - CAP theorem implications

3. **Polyglot persistence architecture**
   - Using multiple databases for different workloads
   - Integration and consistency challenges
   - Operational complexity management

4. **Real-world implementation considerations**
   - Cache invalidation strategies
   - Consistency vs. availability trade-offs
   - Infrastructure and cost implications

## Further Reading

### Recommended Resources

**Books:**
- *Designing Data-Intensive Applications* by Martin Kleppmann
- *NoSQL Distilled* by Martin Fowler & Pramod Sadalage
- *Redis in Action* by Josiah Carlson
- *MongoDB: The Definitive Guide* by Shannon Bradshaw

**Online Resources:**
- Redis University (free courses)
- MongoDB University (free courses)
- AWS Database Blog (architecture patterns)
- Martin Fowler's blog (polyglot persistence)

**Academic Papers:**
- "CAP Theorem" by Eric Brewer
- "Dynamo: Amazon's Highly Available Key-value Store"
- "Bigtable: A Distributed Storage System for Structured Data"

## Submission Checklist

Before submitting, verify:

- [ ] PDF is properly formatted
- [ ] All 3 tasks covered (1-2 pages each)
- [ ] Introduction and conclusion included
- [ ] References section complete (15+ sources)
- [ ] Citations formatted consistently
- [ ] No plagiarism (all paraphrased or cited)
- [ ] AI usage documented in README
- [ ] File named correctly: `HW-4.pdf`
- [ ] `hw4_readme.md` included
- [ ] Spell-checked and proofread

## Grading Criteria (Expected)

Based on assignment requirements:

**Content Quality (60%)**
- Technical accuracy of NoSQL explanations
- Depth of research and analysis
- Quality of real-world examples
- Understanding of trade-offs

**Academic Writing (20%)**
- Clear structure and organization
- Proper citations and references
- Grammar and spelling
- Professional tone

**Completeness (20%)**
- All 3 tasks addressed
- 1-2 pages per task
- Introduction and conclusion
- Minimum source requirements met

## Contact

For questions about this homework or the research paper, please:
- Review ECON485 course materials
- Consult instructor office hours
- Check course discussion forum

---

## Repository Structure


```
HW-4/
  hw4_readme.md
  HW-4.pdf
```


## Version History

- v1.0 (2025-12-25): Initial submission
  - Complete research paper
  - All 3 tasks analyzed
  - 15+ sources cited
  - 9-10 pages total

---

**Note:** This homework demonstrates research and analytical skills in evaluating database technologies. The focus is on understanding when and why to use NoSQL databases rather than implementation details.
