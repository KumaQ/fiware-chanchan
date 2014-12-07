
var express = require('express'),
    auth =    require('./auth'),
    site =    require('./site'),
    orion_pep =  require('./routes/orion_pep'),
    orion =    require('./routes/orion'),
    ckan =    require('./routes/ckan');

var app = express();

app.use(express.logger());
app.use(express.bodyParser());
app.use(express.cookieParser());
app.use(express.session({secret: '08bf59703922c49573f008b4ce58b5b0'}));
app.configure(function () {
    "use strict";
    app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
    app.use(express.static(__dirname + '/public'));
});

// chanchan app
app.use("/chanchan", express.static(__dirname + '/chanchan'));

// main page
//app.get('/', site.index);
app.get('/', function(req, res) {
    res.redirect('/chanchan');
});
app.get('/login',auth.login);
app.get('/logout',auth.logout);
app.get('/auth',auth.auth);


// api rest: /api/
//
// orion_pep
app.get('/api/orion-pep/contexts',orion_pep.contexts);
// orion
app.get('/api/orion/contexts',orion.contexts);
app.post('/api/orion/contexts/:org_id/:context_id',orion.create_context);
// ckan
app.get('/api/ckan/datasets',ckan.datasets);
app.get('/api/ckan/organizations',ckan.organizations);
app.get('/api/ckan/organization/:org_id',ckan.organization);
app.get('/api/ckan/resource/:resource_id',ckan.resource);
// end api rest

app.get('*', function(req, res, next) {
    var err = new Error();
    err.status = 404;
    next(err);
});

app.use(function(err, req, res, next) {
    if (err.status !== 404) {
	    return next();
    }

    res.status(404);
    res.send(err.message || "ups!");
});

// start server
app.set('port', process.env.PORT || 3000);
var server = app.listen(app.get('port'), function() {
    console.log('Express server listening on port ' + app.get('port'));
});
