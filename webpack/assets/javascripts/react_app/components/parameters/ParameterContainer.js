import React from 'react';
import Parameter from './Parameter';
import helpers from '../../common/helpers';

class ParameterContainer extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      name: this.props.name,
      value: this.props.value,
      type: this.props.type
    };
    helpers.bindMethods(this, [
      'nameChanged',
      'valueChanged',
      'onSubmit']
    );
  }
  nameChanged(e) {
    this.setState({name: e.target.value});
  }
  valueChanged(e) {
    this.setState({value: e.target.value});
  }

  onSubmit(e) {
    e.preventDefault;
  }

  render() {
    return (
    <Parameter
      name={this.state.name}
      value={this.state.value}
      type={this.state.type}
      nameChanged={this.nameChanged}
      valueChanged={this.valueChanged}
      onSubmit={this.onSubmit}
    />);
  }
}

export default ParameterContainer;
