![](https://assets-global.website-files.com/5b69e8315733f2850ec22669/5b749a4663ff82be270ff1f5_GSC%20Lockup%20(Orange%20%3A%20Black).svg)

### Welcome to the take home portion of your interview! We're excited to jam through some technical stuff with you, but first it'll help to get a sense of how you work through data and coding problems. Work through what you can independently, but do feel free to reach out if you have blocking questions or problems.

1) This requires Postgres (9.4+) & Rails(4.2+), so if you don't already have both installed, please install them.

2) Download the data file from: https://github.com/gospotcheck/ps-code-challenge/blob/master/Street%20Cafes%202020-21.csv

3) Add a varchar column to the table called `category`.

4) Create a view with the following columns[provide the view SQL]
    - post_code: The Post Code
    - total_places: The number of places in that Post Code
    - total_chairs: The total number of chairs in that Post Code
    - chairs_pct: Out of all the chairs at all the Post Codes, what percentage does this Post Code represent (should sum to 100% in the whole view)
    - place_with_max_chairs: The name of the place with the most chairs in that Post Code
    - max_chairs: The number of chairs at the place_with_max_chairs

#### Description of how this was verified
I took several steps to validate the results of this view.

First, I validated that the number of rows in the report matched the total number of rows when selecting distinct post codes from the cafes table, to ensure the query didn't result in any duplicate results.

Second, I validated that the count of place & sum of chairs per post code was accurate by comparing with standalone queries to return those results per post code.

Third, after writing the query to calculate chairs_pct, I used the entire view query as a subquery and summed the chairs_pct field to validate it equaled 100.

Finally, I verified the place with the most chairs by first writing that query separately from the view query and contrasting the results. I then appended a temporary case statement to the view query to validate that (A) in post codes with one place, the max chairs equaled the amount at that one place, (B) in post codes with more than one place the max chairs was less than total chairs, & (C) that in post codes with more than one place it was mathematically not possible for there to be another cafe with more chairs. This works for all but three post codes where the largest cafe has only a plurality of chairs. I was able to manually validate those given the small size of the dataset. See below for this validation added to the main select statement of the view query.

```
CASE
   WHEN (COUNT(c.id) = 1) AND (MAX(c5.chairs) = SUM(c.chairs)) THEN TRUE
   WHEN (COUNT(c.id) > 1) AND (MAX(c5.chairs) < SUM(c.chairs)) THEN TRUE
   ELSE FALSE
END as verify_first,
CASE
 WHEN (COUNT(c.id) = 1) THEN 'n/a'
 WHEN (SUM(c.chairs) - MAX(c5.chairs) < MAX(c5.chairs)) THEN 'true'
 ELSE 'false'
END as verify_second
```

#### SQL for #4
```
SELECT	c.post_code,
		    COUNT(c.id) as total_places,
	      SUM(c.chairs) as total_chairs,
        ROUND(CAST((SUM(c.chairs)::float /
          (SELECT SUM(c2.chairs) FROM cafes c2) *
           100) as numeric), 2) as pct_chairs,
        MAX(c5.name) as place_with_max_chairs,
        MAX(c5.chairs) as max_chairs
FROM cafes c
LEFT JOIN (SELECT c3.name, c3.post_code, c3.chairs
	FROM cafes c3
	WHERE (c3.post_code, c3.chairs) IN ( SELECT c4.post_code, MAX(c4.chairs) FROM cafes c4 GROUP BY c4.post_code)) c5
ON c.post_code = c5.post_code
GROUP BY c.post_code
ORDER BY c.post_code
```

5) Write a Rails script to categorize the cafes and write the result to the category according to the rules:[provide the script]
    - If the Post Code is of the LS1 prefix type:
        - `# of chairs less than 10: category = 'ls1 small'`
        - `# of chairs greater than or equal to 10, less than 100: category = 'ls1 medium'`
        - `# of chairs greater than or equal to 100: category = 'ls1 large' `
    - If the Post Code is of the LS2 prefix type:
        - `# of chairs below the 50th percentile for ls2: category = 'ls2 small'`
        - `# of chairs above the 50th percentile for ls2: category = 'ls2 large'`
    - For Post Code is something else:
        - `category = 'other'`
#### Script for #5
I opted to handle this in a set of methods in the `Cafe` model that run automatically on save of a record.
```
def set_category
  category =
    case post_code[0..2]
    when 'LS1'
      set_ls1_category
    when 'LS2'
      set_ls2_category
    else
      'other'
    end
  self.category = category
end

def set_ls1_category
  case chairs
  when 0..9
    'ls1 small'
  when 10..100
    'ls1 medium'
  else
    'ls1 large'
  end
end

def set_ls2_category
  cafes = Cafe.where("cafes.post_code LIKE 'LS2%'").map(&:chairs).sort
  count = cafes.count
  return 'ls2 large' if count <= 1

  median = find_median(cafes, count)
  chairs < median ? 'ls2 small' : 'ls2 large'
end

def find_median(cafes, count)
  if (count % 2).zero?
    first_half = (cafes[0...(count / 2)])
    second_half = (cafes[(count / 2)..-1])
    (first_half[-1] + second_half[0]) / 2.to_f
  else
    cafes[(count / 2).floor]
  end
end
```

#### Tests for #5
```
describe 'set_category' do
  describe 'sets correct category for LS1 prefixes' do
    it 'sets small category' do
      cafe = Cafe.create!(@ls1_cafe_small)
      expect(cafe.category).to eq("ls1 small")
    end
    it 'sets medium category' do
      cafe = Cafe.create!(@ls1_cafe_medium)
      expect(cafe.category).to eq("ls1 medium")
    end
    it 'sets large category' do
      cafe = Cafe.create!(@ls1_cafe_large)
      expect(cafe.category).to eq("ls1 large")
    end
  end
  describe 'sets correct category for LS2 prefixes' do
    it 'sets small category' do
      cafe = Cafe.create!(@ls2_cafe_small)
      expect(cafe.category).to eq("ls2 small")
    end
    it 'sets large category' do
      cafe = Cafe.create!(@ls2_cafe_large)
      expect(cafe.category).to eq("ls2 large")
    end
  end
  describe 'sets correct category for other prefixes' do
    it 'sets small category' do
      cafe = Cafe.create!(@lso_cafe_one)
      expect(cafe.category).to eq("other")
    end
    it 'sets medium category' do
      cafe = Cafe.create!(@lso_cafe_two)
      expect(cafe.category).to eq("other")
    end
  end
  describe 'sets correct category on updates' do
    it 'updates LS1 categories' do
      cafe = Cafe.create!(@ls1_cafe_small)
      expect(cafe.category).to eq("ls1 small")

      @ls1_cafe_small[:chairs] = Faker::Number.number(digits: 3)
      cafe.update!(@ls1_cafe_small)
      expect(cafe.category).to eq("ls1 large")
    end
    it 'updates LS2 categories' do
      cafe = Cafe.create!(@ls2_cafe_small)
      expect(cafe.category).to eq("ls2 small")

      @ls2_cafe_small[:chairs] = Faker::Number.number(digits: 4)
      cafe.update!(@ls2_cafe_small)
      expect(cafe.category).to eq("ls2 large")
    end
    it 'updates other categories' do
      cafe = Cafe.create!(@ls2_cafe_small)
      expect(cafe.category).to eq("ls2 small")

      @ls2_cafe_small[:post_code] = "LS8 #{Faker::Number.number(digits: 1)}#{Faker::Alphanumeric.alpha(number: 2)}"
      cafe.update!(@ls2_cafe_small)
      expect(cafe.category).to eq("other")

      @ls2_cafe_small[:post_code] = "LS1 #{Faker::Number.number(digits: 1)}#{Faker::Alphanumeric.alpha(number: 2)}"
      cafe.update!(@ls2_cafe_small)
      expect(cafe.category).to eq("ls1 small")
    end
  end
end
```

6) Write a custom view to aggregate the categories [provide view SQL AND the results of this view]
    - category: The category column
    - total_places: The number of places in that category
    - total_chairs: The total chairs in that category

#### SQL to create view for #6
```
SELECT 	c.category,
		    COUNT(c.id) as total_places,
		    SUM(c.chairs) as total_chairs
FROM cafes c
GROUP BY c.category
ORDER BY c.category

```

#### Results of view for #6
```
category  | total_places | total_chairs
------------+--------------+--------------
ls1 large  |            1 |          152
ls1 medium |           48 |         1238
ls2 large  |            5 |          458
other      |            1 |           32
(4 rows)

```

7) Write a script in rails to:
    - For street_cafes categorized as small, write a script that exports their data to a csv and deletes the records
    - For street cafes categorized as medium or large, write a script that concatenates the category name to the beginning of the name and writes it back to the name column

#### Tests for #7
```    
describe 'modify cafes' do
  it 'delete_small_cafes' do
    small_cafes = Cafe.where("cafes.category LIKE '%small'")
    small_count = small_cafes.size
    expect(Cafe.all.size).to eq(5)

    Cafe.delete_small_cafes

    small_cafes.reload
    expect(small_cafes).to eq([])
    expect(Cafe.all.size).to eq(5 - small_count)
  end
  it 'concatenate_med_large_cafes' do
    med_large_cafes = Cafe.where("cafes.category LIKE '%medium' OR cafes.category LIKE '%large'")

    expect(med_large_cafes[0].name).not_to include("large-")
    Cafe.concatenate_med_large_cafes
    med_large_cafes = Cafe.where("cafes.category LIKE '%medium' OR cafes.category LIKE '%large'")

    expect(med_large_cafes[0].name).to include("large-")
  end
end
```

8) Show your work and check your email for submission instructions.

9) Celebrate, you did great!
- Thank you! This was fun!
