--No.88 ギミック・パペット－デステニー・レオ
function c511002600.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,3)
	c:EnableReviveLimit()
	--detach
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(48995978,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c511002600.target)
	e1:SetOperation(c511002600.operation)
	c:RegisterEffect(e1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c511002600.indes)
	c:RegisterEffect(e2)
	if not c511002600.global_check then
		c511002600.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c511002600.numchk)
		Duel.RegisterEffect(ge2,0)
	end
end
c511002600.xyz_number=88
function c511002600.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
end
function c511002600.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:RemoveOverlayCard(tp,1,1,REASON_EFFECT) then
		if c:GetOverlayCount()==0 then
			local WIN_REASON_DESTINY_LEO=0x17
			Duel.Win(c:GetControler(),WIN_REASON_DESTINY_LEO)
		end
	end
end
function c511002600.numchk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,48995978)
	Duel.CreateToken(1-tp,48995978)
end
function c511002600.indes(e,c)
	return not c:IsSetCard(0x48)
end
