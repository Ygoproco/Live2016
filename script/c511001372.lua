--CNo.88 ギミック・パペット－ディザスター・レオ
function c511001372.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,4)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c511001372.efilter)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6165656,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(c511001372.con)
	e2:SetCost(c511001372.cost)
	e2:SetTarget(c511001372.target)
	e2:SetOperation(c511001372.operation)
	c:RegisterEffect(e2)
	--win
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetCondition(c511001372.con)
	e4:SetOperation(c511001372.winop)
	c:RegisterEffect(e4)
	if not c511001372.global_check then
		c511001372.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c511001372.numchk)
		Duel.RegisterEffect(ge2,0)
	end
end
c511001372.xyz_number=88
function c511001372.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
function c511001372.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,48995978)
end
function c511001372.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c511001372.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2000)
end
function c511001372.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c511001372.winop(e,tp,eg,ep,ev,re,r,rp)
	local ov=e:GetHandler():GetOverlayGroup()
	local g=ov:FilterSelect(tp,Card.IsCode,1,1,nil,48995978)
	Duel.SendtoGrave(g,REASON_EFFECT)
	if e:GetHandler():GetOverlayCount()==0 then
		local WIN_REASON_DISASTER_LEO=0x18
		Duel.Win(tp,WIN_REASON_DISASTER_LEO)
	end
end
function c511001372.numchk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,6165656)
	Duel.CreateToken(1-tp,6165656)
end
