# ComponentName

## Overview
Brief description of the component's purpose and when to use it.

## Import
```javascript
import { ComponentName } from './path/to/ComponentName';
```

## Props/Parameters

| Prop | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| `title` | string | Yes | - | The title text to display |
| `variant` | 'primary' \| 'secondary' \| 'danger' | No | 'primary' | Visual style variant |
| `size` | 'small' \| 'medium' \| 'large' | No | 'medium' | Component size |
| `disabled` | boolean | No | false | Whether the component is disabled |
| `onClick` | (event: Event) => void | No | - | Click event handler |
| `className` | string | No | - | Additional CSS classes |
| `children` | ReactNode | No | - | Child elements to render |

## Events

| Event | Parameters | Description |
|-------|------------|-------------|
| `onClick` | `event: Event` | Fired when component is clicked |
| `onHover` | `event: Event` | Fired when component is hovered |
| `onChange` | `value: any` | Fired when component value changes |

## Styling

### CSS Classes
- `.component-name` - Base component class
- `.component-name--primary` - Primary variant styling
- `.component-name--disabled` - Disabled state styling
- `.component-name__title` - Title element styling

### CSS Variables
```css
:root {
  --component-background: #ffffff;
  --component-text-color: #333333;
  --component-border-radius: 4px;
  --component-padding: 12px 16px;
}
```

## Basic Usage

```javascript
// Basic usage
<ComponentName title="Hello World" />

// With variant
<ComponentName 
  title="Click me" 
  variant="primary"
  onClick={(e) => console.log('Clicked!')}
/>

// With all props
<ComponentName
  title="Advanced Example"
  variant="secondary"
  size="large"
  disabled={false}
  className="custom-class"
  onClick={handleClick}
>
  <span>Additional content</span>
</ComponentName>
```

## Advanced Examples

### With State Management
```javascript
import React, { useState } from 'react';
import { ComponentName } from './ComponentName';

function ExampleApp() {
  const [isActive, setIsActive] = useState(false);

  return (
    <ComponentName
      title={isActive ? "Active" : "Inactive"}
      variant={isActive ? "primary" : "secondary"}
      onClick={() => setIsActive(!isActive)}
    />
  );
}
```

### With Custom Styling
```javascript
<ComponentName
  title="Styled Component"
  className="my-custom-component"
  style={{
    backgroundColor: '#f0f0f0',
    borderRadius: '8px'
  }}
/>
```

### Integration with Forms
```javascript
<form onSubmit={handleSubmit}>
  <ComponentName
    title="Submit"
    variant="primary"
    type="submit"
    disabled={!isFormValid}
  />
</form>
```

## Accessibility

- **ARIA Support**: Component includes proper ARIA attributes
- **Keyboard Navigation**: Supports Tab, Enter, and Space key navigation
- **Screen Reader**: Compatible with screen readers
- **Focus Management**: Proper focus indicators and management

### ARIA Attributes
- `aria-label`: Provides accessible name
- `aria-disabled`: Indicates disabled state
- `role`: Defines the component's role

## Browser Support

| Browser | Version |
|---------|---------|
| Chrome | 80+ |
| Firefox | 75+ |
| Safari | 13+ |
| Edge | 80+ |

## Performance

- **Bundle Size**: ~2KB gzipped
- **Render Time**: < 1ms typical
- **Memory Usage**: Minimal
- **Re-render Optimization**: Uses React.memo for performance

## Testing

### Unit Tests
```javascript
import { render, fireEvent } from '@testing-library/react';
import { ComponentName } from './ComponentName';

test('renders with title', () => {
  const { getByText } = render(<ComponentName title="Test" />);
  expect(getByText('Test')).toBeInTheDocument();
});

test('calls onClick when clicked', () => {
  const handleClick = jest.fn();
  const { getByRole } = render(
    <ComponentName title="Click" onClick={handleClick} />
  );
  
  fireEvent.click(getByRole('button'));
  expect(handleClick).toHaveBeenCalledTimes(1);
});
```

### Visual Testing
```javascript
// Storybook story
export default {
  title: 'Components/ComponentName',
  component: ComponentName,
};

export const Default = () => <ComponentName title="Default" />;
export const Primary = () => <ComponentName title="Primary" variant="primary" />;
export const Disabled = () => <ComponentName title="Disabled" disabled />;
```

## Related Components

- [RelatedComponent](./related-component.md) - Similar functionality
- [AnotherComponent](./another-component.md) - Often used together

## Migration Guide

### From v1.x to v2.x
- Prop `color` renamed to `variant`
- Event `onPress` renamed to `onClick`
- CSS class `btn` changed to `component-name`

## Troubleshooting

### Common Issues

**Issue**: Component not rendering
**Solution**: Ensure all required props are provided

**Issue**: Styling not applied
**Solution**: Check that CSS is imported and class names are correct

**Issue**: Click handler not working
**Solution**: Verify onClick prop is a function and component is not disabled

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 2.1.0 | 2023-03-01 | Added size prop, improved accessibility |
| 2.0.0 | 2023-02-01 | Breaking: Renamed props, updated styling |
| 1.0.0 | 2023-01-01 | Initial release |