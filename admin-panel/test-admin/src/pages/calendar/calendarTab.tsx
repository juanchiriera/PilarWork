import { useEffect, useState } from 'react';
import { ShowButton, CreateButton, useRefresh, DeleteWithConfirmButton  } from 'react-admin';
import axios from 'axios';
import { DateCalendar } from '@mui/x-date-pickers/DateCalendar';
import { PickersDay, PickersDayProps } from '@mui/x-date-pickers/PickersDay';
import { Badge, Box, Modal, Typography, Paper, CircularProgress, Stack  } from '@mui/material';
import dayjs, { Dayjs } from 'dayjs';
import isBetween from 'dayjs/plugin/isBetween';
dayjs.extend(isBetween);


interface Reservation {
    id: string;
    personas: string[];
    fechaInicio: string;
    fechaFin: string;
    cliente: string;
    elementos: string[];
}

const CalendarTab = () => {
    const [reservations, setReservations] = useState<Reservation[]>([]);
    const [selectedDate, setSelectedDate] = useState<Dayjs | null>(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [modalOpen, setModalOpen] = useState(false);
    const [currentMonth, setCurrentMonth] = useState<Dayjs>(dayjs());
    const refresh = useRefresh();

    useEffect(() => {
        const fetchReservations = async () => {
            try {
                const startOfMonth = currentMonth.startOf('month').format('YYYY-MM-DD');
                const endOfMonth = currentMonth.endOf('month').format('YYYY-MM-DD');
                
                const response = await axios.get('http://localhost:3000/api/reservas', {
                    params: {
                        fechaInicio: startOfMonth,
                        fechaFin: endOfMonth
                    }
                });
                
                setReservations(response.data);
                setLoading(false);
            } catch (err) {
                setError('Error al cargar reservaciones');
                setLoading(false);
            }
        };

        fetchReservations();
    }, [currentMonth]);

    const handleDeleteSuccess = (id: string) => {
        setReservations(prev => prev.filter(r => r.id !== id));
        refresh();
    };

    const getReservationsForDate = (date: Dayjs) => {
        return reservations.filter(reservation => {
            const start = dayjs(reservation.fechaInicio);
            const end = dayjs(reservation.fechaFin);
            return date.isBetween(start, end, 'day', '[]');
        });
    };

    const CustomDay = (props: PickersDayProps<Dayjs>) => {
        const { day, ...other } = props;
        const isReserved = reservations.some(reservation => 
            day.isBetween(
                dayjs(reservation.fechaInicio),
                dayjs(reservation.fechaFin),
                'day',
                '[]'
            )
        );

        const handleClick = () => {
            setSelectedDate(day);
            setModalOpen(true);
        };

    if (loading) return <CircularProgress sx={{ margin: 'auto' }} />;
    if (error) return <Typography color="error">{error}</Typography>;
        return (
            <Badge
                key={day.toString()}
                overlap="circular"
                badgeContent={isReserved ? (
                    <div style={{
                        background: '#ff0000',
                        width: 8,
                        height: 8,
                        borderRadius: '50%'
                    }} />
                ) : undefined}
            >
                <PickersDay 
                    {...other} 
                    day={day} 
                    onClick={handleClick}
                    sx={{
                        '&:hover': {
                            backgroundColor: '#f0f0f0',
                            cursor: 'pointer'
                        }
                    }}
                />
            </Badge>
        );
    };

    if (loading) return <CircularProgress sx={{ margin: 'auto' }} />;
    if (error) return <Typography color="error">{error}</Typography>;

    return (
        <Box sx={{ 
            maxWidth: 800, 
            width: '100%',
            margin: 'auto',
            padding: 3
        }}>
            <Box sx={{ mb: 2, display: 'flex', justifyContent: 'flex-end' }}>
                <CreateButton 
                    resource="reservas"
                    sx={{ 
                        backgroundColor: '#4CAF50',
                        '&:hover': { backgroundColor: '#45a049' }
                    }}
                />
            </Box>

            <DateCalendar
                value={currentMonth}
                onMonthChange={setCurrentMonth}
                slots={{ day: CustomDay }}
                sx={{
                    '& .MuiDateCalendar-root': {
                        width: '100%',
                        height: '100%'
                    }
                }}
            />
            
            <Modal
                open={modalOpen}
                onClose={() => setModalOpen(false)}
                sx={{ display: 'flex', alignItems: 'center', justifyContent: 'center' }}
            >
                <Paper sx={{ 
                    padding: 3, 
                    width: 400,
                    maxHeight: '60vh',
                    overflow: 'auto'
                }}>
                    <Typography variant="h6" gutterBottom>
                        Reservas del {selectedDate?.format('DD/MM/YYYY')}
                    </Typography>
                    
                    {selectedDate && reservations
                        .filter(r => dayjs(r.fechaInicio).isSame(selectedDate, 'day'))
                        .map(reservation => (
                            <Paper 
                                key={reservation.id}
                                sx={{ 
                                    mb: 2,
                                    p: 2,
                                    border: '1px solid #e0e0e0',
                                    borderRadius: 1,
                                    position: 'relative'
                                }}
                            >
                                <Stack direction="column" spacing={1}>
                                    <Typography variant="body2">
                                        <strong>Horario:</strong> {dayjs(reservation.fechaInicio).format('HH:mm')} - {dayjs(reservation.fechaFin).format('HH:mm')}
                                    </Typography>
                                    <Typography variant="body2">
                                        <strong>Personas:</strong> {reservation.personas.join(', ')}
                                    </Typography>
                                    
                                    <Stack 
                                        direction="row" 
                                        spacing={1} 
                                        sx={{ mt: 1, justifyContent: 'flex-end' }}
                                    >
                                        <ShowButton 
                                            resource="reservas"
                                            record={reservation}
                                            sx={{ 
                                                color: '#2196F3',
                                                '&:hover': { backgroundColor: '#e3f2fd' }
                                            }}
                                        />
                                        
                                        <DeleteWithConfirmButton
                                            resource="reservas"
                                            record={reservation}
                                            confirmTitle="Eliminar reserva"
                                            confirmContent="¿Estás seguro de eliminar esta reserva?"
                                            mutationOptions={{
                                                onSuccess: () => handleDeleteSuccess(reservation.id)
                                            }}
                                        />
                                    </Stack>
                                </Stack>
                            </Paper>
                        ))}
                    
                    {selectedDate && getReservationsForDate(selectedDate).length === 0 && (
                        <Typography variant="body2" color="textSecondary">
                            No hay reservaciones para este día
                        </Typography>
                        )}
                </Paper>
            </Modal>
        </Box>
    );
};

export default CalendarTab;