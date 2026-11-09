iMASS INNOVATION — COMPLETE MULTI-PAGE WEBSITE

STRUCTURE
- index.html                         Homepage
- about/index.html                   About
- research-innovation/index.html     Research & Innovation
- study/index.html                   Study & Learning
- collaborate/index.html             Collaboration
- contact-us/index.html              Contact
- donate/index.html                  Support our work
- styles.css                         Shared responsive stylesheet
- script.js                          Shared navigation and interaction script
- images/                            Website photography
- assets/                            Logo and brand assets
- .htaccess                           Apache clean-URL configuration

IMPORTANT ARCHITECTURE
Every page is a complete, independent HTML document. Each page contains its own
header, navigation, main content and footer. Pages share styles.css and script.js.
Internal navigation and shared resources use relative paths:
- Homepage: ./about/ and styles.css
- Nested pages: ../about/ and ../styles.css

DEPLOYMENT
Upload the contents of this folder into the public web root (often public_html).
Do not upload the ZIP itself as the website. Keep the folder structure intact.
Apache hosting uses .htaccess for directory index and 404 handling.
For IIS hosting, retain web.config.

LOCAL PREVIEW
Use the included START-LOCAL-PREVIEW.bat where supported, or run a local static
server from this folder (for example: python -m http.server 8000) and open
http://localhost:8000 in a browser.

NOTES
- Contact details and bank-transfer information are carried over from the supplied
  website files. Confirm them with the organisation before publishing.
- Course availability, research outputs, funding arrangements and programme dates
  are not invented; contact the organisation for current details.


APACHE DIRECTORY LISTING FIX
If Apache still shows "Index of .../about/" instead of opening about/index.html,
Apache is likely ignoring .htaccess or the website folder is not configured as the
DocumentRoot. In Apache's httpd.conf, enable overrides for the website directory:

<Directory "D:/All-in-one/iMass_Innovation_Complete_Website">
    Options FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>

Also ensure the directory is configured as the correct DocumentRoot or placed
inside Apache's htdocs. Restart Apache after changing httpd.conf. The .htaccess
file must be in the website root, alongside the main index.html.


SEO IMPLEMENTATION NOTES
- Each HTML page has a unique search title and meta description, Open Graph/Twitter metadata, canonical URL, and structured data.
- Once the real domain is confirmed, create sitemap.xml with absolute URLs for all pages and add its URL to robots.txt.
- SEO IMPLEMENTATION
- Every public HTML page has a unique title and description, canonical URL, Open Graph and Twitter metadata, and JSON-LD structured data.
- The canonical domain is https://imassinnovation.org/ (non-www, HTTPS).
- sitemap.xml lists the homepage and all six public section pages.
- robots.txt allows normal crawling and points search engines to the XML sitemap.
- 404.html is intentionally marked noindex so missing URLs are not indexed.
- Submit https://imassinnovation.org/sitemap.xml in Google Search Console after the site is live.
- SEO setup helps search engines understand the website but cannot guarantee rankings. Results also depend on useful content, technical performance, accessibility, mobile usability and reputable references.
- Keep sitemap.xml and canonical URLs updated whenever public pages are added, removed or renamed.
