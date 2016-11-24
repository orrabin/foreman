import React from 'react';
import Input from '../common/Form/Input';
import '../common/Form/Input.css';

const Parameter = ({
  name,
  value,
  id = Date.now(),
  type = 'text',
  nameChanged,
  valueChanged,
  nameValidation,
  valueValidation,
  errors = {}
 }) => {

  const validator = (context) => {
   if (name.length > 256) {
     nameValidation = 'name is too long'
     return 'error'
   }
   else if (name.length < 1) {
     nameValidation = 'name is too short'
     return 'error'
   }
  };

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
        validator={validator()}
        valueValidation = {nameValidation}
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
