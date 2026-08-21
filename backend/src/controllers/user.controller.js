let userProfile = {
  id: 'usr_1',
  name: 'Julian Thorne',
  email: 'julian.thorne@example.com',
  phone: '+1 (415) 555-0198',
  gender: 'Male',
  avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=80',
  isVerified: true,
  themeMode: 'system',
  language: 'en',
  notificationsEnabled: true,
};

let userAddresses = [
  {
    id: 'addr_1',
    label: 'Home',
    recipientName: 'Julian Thorne',
    phoneNumber: '+1 (415) 555-0198',
    streetAddress: '842 Aurora Blvd, Suite 4',
    apartment: 'San Francisco, CA 94110, USA',
    city: 'San Francisco',
    postalCode: '94110',
    isDefault: true,
  },
  {
    id: 'addr_2',
    label: 'Work',
    recipientName: 'Julian Thorne',
    phoneNumber: '+1 (415) 555-0198',
    streetAddress: '100 Market St, Floor 14',
    apartment: 'Tech Tower',
    city: 'San Francisco',
    postalCode: '94105',
    isDefault: false,
  },
];

export async function getProfile(req, res) {
  res.json({
    success: true,
    data: userProfile,
  });
}

export async function updateProfile(req, res) {
  const { name, email, phone, gender, avatarUrl } = req.body;
  if (name) userProfile.name = name;
  if (email) userProfile.email = email;
  if (phone) userProfile.phone = phone;
  if (gender) userProfile.gender = gender;
  if (avatarUrl) userProfile.avatarUrl = avatarUrl;

  res.json({
    success: true,
    data: userProfile,
    message: 'Profile updated successfully',
  });
}

export async function getPreferences(req, res) {
  res.json({
    success: true,
    data: {
      themeMode: userProfile.themeMode,
      language: userProfile.language,
      notificationsEnabled: userProfile.notificationsEnabled,
    },
  });
}

export async function updatePreferences(req, res) {
  const { themeMode, language, notificationsEnabled } = req.body;
  if (themeMode !== undefined) userProfile.themeMode = themeMode;
  if (language !== undefined) userProfile.language = language;
  if (notificationsEnabled !== undefined) userProfile.notificationsEnabled = notificationsEnabled;

  res.json({
    success: true,
    data: {
      themeMode: userProfile.themeMode,
      language: userProfile.language,
      notificationsEnabled: userProfile.notificationsEnabled,
    },
    message: 'Preferences updated successfully',
  });
}

export async function getAddresses(req, res) {
  res.json({
    success: true,
    data: userAddresses,
    total: userAddresses.length,
  });
}

export async function addAddress(req, res) {
  const { label, recipientName, phoneNumber, streetAddress, apartment, city, postalCode, isDefault } = req.body;
  
  if (isDefault) {
    userAddresses = userAddresses.map((a) => ({ ...a, isDefault: false }));
  }

  const newAddr = {
    id: `addr_${Date.now()}`,
    label: label || 'Home',
    recipientName: recipientName || userProfile.name,
    phoneNumber: phoneNumber || userProfile.phone,
    streetAddress: streetAddress || '',
    apartment: apartment || '',
    city: city || 'San Francisco',
    postalCode: postalCode || '94110',
    isDefault: !!isDefault,
  };

  userAddresses.push(newAddr);

  res.status(201).json({
    success: true,
    data: newAddr,
    message: 'Address added successfully',
  });
}

export async function updateAddress(req, res) {
  const { id } = req.params;
  const idx = userAddresses.findIndex((a) => a.id === id);

  if (idx === -1) {
    return res.status(404).json({ success: false, error: 'Address not found' });
  }

  if (req.body.isDefault) {
    userAddresses = userAddresses.map((a) => ({ ...a, isDefault: false }));
  }

  userAddresses[idx] = {
    ...userAddresses[idx],
    ...req.body,
  };

  res.json({
    success: true,
    data: userAddresses[idx],
    message: 'Address updated successfully',
  });
}

export async function deleteAddress(req, res) {
  const { id } = req.params;
  userAddresses = userAddresses.filter((a) => a.id !== id);

  res.json({
    success: true,
    message: 'Address deleted successfully',
  });
}
