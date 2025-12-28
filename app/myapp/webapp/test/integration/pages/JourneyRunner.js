sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"myapp/test/integration/pages/ActivitiesList",
	"myapp/test/integration/pages/ActivitiesObjectPage"
], function (JourneyRunner, ActivitiesList, ActivitiesObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('myapp') + '/test/flp.html#app-preview',
        pages: {
			onTheActivitiesList: ActivitiesList,
			onTheActivitiesObjectPage: ActivitiesObjectPage
        },
        async: true
    });

    return runner;
});

