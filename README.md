As far as we know, there is no public open source tool which calculates the percentage of a city's area dedicated to publicly accessible park space. This information is important for various reasons. For example, keeping track of this figure along with the changes that occur throughout time would allow city planners to investigate why this is happening, and if there should be policies put in place to secure their survival.

Our goal is to have this figure publicly available for ALL cities which have been sufficiently mapped on Google Maps. On the aggregate, the table would look something like this: 

http://www.worldcitiescultureforum.com/data/of-public-green-space-parks-and-gardens 


All code written to create these calculations will be posted in this repository.


Parks will be retrieved using a two-pronged approach: (1) retrieving all spaces which are identified as parks in Google Maps, and (2) retrieving all green spaces in Google Maps, and determining if they're parks using reverse geocoding. These two approaches will be combined in a way to maximize the coverage of parks.


Part 1

a. retrieve_parks

Making a call to the Google Places API for all parks within a 300m radius of a given location will bring back a list of the 20 closest parks. Calling this iteratively across an entire city will bring back all city parks labelled as such. Next, we project a shape file of the city over the locations of the parks in the list. With this, we keep which parks are inside the city.

b. retrieve_areas

With the list of a city's park names and locations, we can then call the Google API to take snapshots of each park at a specified zoom. Having a specific zoom allows us to properly scale the size of the park. There are 1,638,400 pixels in each snapshot, at zoom level 15, these roughly translate to one square meter per pixel. Given the zoom level is relatively low, other parks may be included in the snapshot. To fix this, we strip a snapshot from all but the park colors, then run the watershed algorithm to differentiate the parks from each other. After this, we select the non white pixels which are closest to the center of the screen, and sum the number of pixels this cluster has. This relates to the size in square meters of the chosen park. 

