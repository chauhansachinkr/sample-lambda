Documents/projects/architecture/cf-sg-update
sam local invoke sgUpdate -e testevent.json -d 5890 -t samtemplate.yaml 
pip install ptvsd -t .
