import React from 'react';

/* eslint-disable no-unused-vars */
import { storiesOf, action, linkTo, addDecorator } from '@kadira/storybook';
require('../assets/javascripts/bundle');
require('../../app/assets/javascripts/application');
import StatisticsChartsList from
'../assets/javascripts/react_app/components/charts/StatisticsChartsList';
import StatisticsChartBox from
'../assets/javascripts/react_app/components/charts/StatisticsChartBox';
import Search from '../assets/javascripts/react_app/components/common/Search';
import Toast from '../assets/javascripts/react_app/components/notifications/Toast';

addDecorator((story) => (
  <div className="ca" style={{textAlign: 'center'}}>
    {story()}
    <div id="targetChart"></div>
  </div>
));

storiesOf('Search', module)
  .add('Initial State', () => (
    <Search />
  ))
  .add('with Existing query', () => (
    <Search query="query" />
  )
);

storiesOf('Notifications', module)
  .add('Success State', () => (
    <Toast title="Great Succees!" />
  ))
  .add('Error', () => (
    <Toast message="Please don't do that again" type="danger"/>
  ))
  .add('Success with link', () => (
    <Toast title="Payment recieved"
      link="click for details" />
  ))
  .add('Warning', () => (
    <Toast message="I'm not sure you should do that" type="warning"/>
  )
);

storiesOf('Statistics', module)
  .add('Loading', () => (
    <StatisticsChartBox
      config={{data: {columns: [] }}}
      noDataMsg={'No data here'}
      title="Title"
      status="PENDING" />
  ))
    .add('Without Data', () => (
    <StatisticsChartBox
      config={{data: {columns: [] }}}
      noDataMsg={'No data here'}
      title="Title"
      status="RESOLVED" />
  ))
    .add('With Error', () => (
    <StatisticsChartBox
      config={{data: {columns: [] }}}
      title="Title"
      noDataMsg={'No data here'}
      errorText="Ooops"
      status="ERROR" />
  ))
  .add('With data', () => (
    <StatisticsChartBox
      config={{data: {columns: [1, 2]}}}
      modalConfig={{}}
      noDataMsg={'No data here'}
      id="target"
      status="RESOLVED"
    />
  )
);
