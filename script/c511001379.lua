--Power Bombard
function c511001379.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(511001265)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c511001379.damcon)
	e1:SetTarget(c511001379.damtg)
	e1:SetOperation(c511001379.damop)
	c:RegisterEffect(e1)
	if not c511001379.global_check then
		c511001379.global_check=true
		--register
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c511001379.atkchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511001379.atkchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,419)==0 and Duel.GetFlagEffect(1-tp,419)==0 then
		Duel.CreateToken(tp,419)
		Duel.CreateToken(1-tp,419)
		Duel.RegisterFlagEffect(tp,419,nil,0,1)
		Duel.RegisterFlagEffect(1-tp,419,nil,0,1)
	end
end
function c511001379.cfilter(c,tp)
	local val=0
	if c:GetFlagEffect(284)>0 then val=c:GetFlagEffectLabel(284) end
	return c:IsControler(tp) and c:GetAttack()~=val
end
function c511001379.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511001379.cfilter,1,nil,tp)
end
function c511001379.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1800)
end
function c511001379.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,1800,REASON_EFFECT)
	end
end
