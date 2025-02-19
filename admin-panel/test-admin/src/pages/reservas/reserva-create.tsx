import { Create, SimpleForm, SelectInput, DateTimeInput, SelectArrayInput, useNotify, useRedirect, required, useGetList, TextInput} from 'react-admin';
import axios from 'axios';
import { useEffect, useState } from 'react';
import dayjs from 'dayjs';
import isSameOrBefore from 'dayjs/plugin/isSameOrBefore';

dayjs.extend(isSameOrBefore);

interface Elemento {
    id: string;
    name: string;
}

interface Espacio {
    id: string;
    name: string;
    elementos: Elemento[];
}

interface ReservaFormValues {
    espacio?: string;
    elementos?: string[];
    fechaInicio?: Date;
    fechaFin?: Date;
    personas?: string;
}

export const ReservaCreate = () => {
    const notify = useNotify();
    const redirect = useRedirect();
    const [elementos, setElementos] = useState<Elemento[]>([]);
    const [selectedEspacioId, setSelectedEspacioId] = useState<string>();
    
    const { data: espacios, isLoading: loadingEspacios } = useGetList<Espacio>('espacios');
    
    useEffect(() => {
        console.log(selectedEspacioId);
        if (selectedEspacioId) {
            axios.get<Espacio>(`http://localhost:3000/api/espacios/${selectedEspacioId}`)
                .then(res => setElementos(res.data.elementos))
                .catch(() => notify('Error cargando elementos', { type: 'error' }));
        }
    }, [selectedEspacioId]);

    const validateReserva = async (values: ReservaFormValues) => {
        const errors: Partial<Record<keyof ReservaFormValues, any>> = {};
        
        if (!values.elementos || values.elementos.length === 0) {
            errors.elementos = 'Seleccione al menos un elemento';
        }

        if (values.fechaInicio && values.fechaFin && 
            dayjs(values.fechaFin).isSameOrBefore(dayjs(values.fechaInicio))) {
            errors.fechaFin = 'La fecha final debe ser posterior a la inicial';
        }

        try {
            if (values.elementos && values.fechaInicio && values.fechaFin) {
                const conflictedElements = await Promise.all(
                    values.elementos.map(async elementoId => {
                        const response = await axios.get<{ disponible: boolean }>(
                            'http://localhost:3000/api/reservas/check',
                            {
                                params: {
                                    elementoId,
                                    fechaInicio: dayjs(values.fechaInicio).toISOString(),
                                    fechaFin: dayjs(values.fechaFin).toISOString()
                                }
                            }
                        );
                        return response.data.disponible ? null : elementoId;
                    })
                );

                const conflictos = conflictedElements.filter(Boolean) as string[];
                if (conflictos.length > 0) {
                    errors.elementos = `Elementos no disponibles: ${
                        elementos.filter(e => conflictos.includes(e.id)).map(e => e.name).join(', ')
                    }`;
                }
            }
        } catch (error) {
            notify('Error validando disponibilidad', { type: 'error' });
        }

        return errors;
    };

    const handleSubmit = async (data: any) => {
        try {
            await axios.post('http://localhost:3000/api/reservas', {
                ...data,
                elementos: data.elementos as string[],
                fechaInicio: dayjs(data.fechaInicio).toISOString(),
                fechaFin: dayjs(data.fechaFin).toISOString(),
                personas: (data.personas || '').split(',').map((p: string) => p.trim()).filter(Boolean)
            });
            
            notify('Reserva creada exitosamente');
            redirect('/reservas');
        } catch (error) {
            notify('Error creando reserva', { type: 'error' });
        }
    };

    return (
        <Create title="Nueva Reserva">
            <SimpleForm
                onSubmit={handleSubmit}
                validate={validateReserva}
                sanitizeEmptyValues
            >
                <SelectInput
                    source="espacio"
                    label="Espacio"
                    choices={espacios || []}
                    optionText="name"
                    optionValue="id"
                    validate={required()}
                    isLoading={loadingEspacios}
                    onChange={value => setSelectedEspacioId(value.target.value)}
                />
                
                <SelectArrayInput
                    source="elementos"
                    label="Elementos"
                    choices={elementos}
                    optionText="name"
                    optionValue="id"
                    validate={required()}
                    disabled={!elementos.length}
                />
                
                <DateTimeInput
                    source="fechaInicio"
                    label="Fecha y Hora Inicio"
                    validate={required()}
                    defaultValue={new Date()}
                />
                
                <DateTimeInput
                    source="fechaFin"
                    label="Fecha y Hora Fin"
                    validate={required()}
                    defaultValue={dayjs().add(2, 'hour').toDate()}
                />
                
                <TextInput
                    source="personas"
                    label="Personas (separar por comas)"
                    validate={required()}
                    fullWidth
                />
            </SimpleForm>
        </Create>
    );
};