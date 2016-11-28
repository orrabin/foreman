import React from 'react';
import Input from '../common/Form/Input';

const Parameter = ({
  name,
  value,
  id = Date.now(),
  type = 'text',
  nameChanged,
  valueChanged,
  errors = {}
 }) => {

  // const validator = (context) => {
  //   return (name.length > 1 ? 'success' : 'warning');
  // };
  const nameLabel = 'Name';
  const valueLabel = 'Value';

  return (
    <div className="form-inline">
      <Input
        id = {id}
        srOnly = {true}
        label = {nameLabel}
        valueChanged = {nameChanged}
        value = {name}
        placeholder = {nameLabel}
        />

      <Input
        id = {id}
        srOnly = {true}
        label = {valueLabel}
        valueChanged = {valueChanged}
        type = {type}
        value = {value}
        placeholder = {valueLabel}
        />
        <a href=""
          className="pficon pficon-close delete-row as-sortable-item-delete"
          role="button"
          aria-label="Delete row"
        />
    </div>
  );
};

export default Parameter;
