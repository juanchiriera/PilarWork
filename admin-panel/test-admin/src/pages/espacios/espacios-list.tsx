import { List, Datagrid, TextField, NumberField, BooleanField } from 'react-admin';

const EspaciosList = (props: any) => (
<List {...props} perPage={10}>
        <Datagrid>
            <TextField source="name" />
            <NumberField source="quantity" />
            <BooleanField source="available" />
        </Datagrid>
    </List>
);

export default EspaciosList;